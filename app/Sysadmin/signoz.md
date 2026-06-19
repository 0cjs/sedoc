SigNoz
======

[SigNoz] accepts logs, metrics and traces from reporters, stores these
data in time series and other databases, has a query engine to generate
stats and graphs from the data, and can generate alerts when certain
conditions are met.

### Architecture

> [!NOTE]
> The term 'collector' is overloaded: a monitored host runs the  'OTel
> collector' [`otelcol`] which collects local data and sends them to the
> 'SigNoz OpenTelemetry Collector' [`signoz-otel-collector`] running on the
> SigNoz host. In this document 'collector' refers _only_ to clients of
> SigNoz, never to anything run on the host running SigNoz or closely
> related to it.

The [architecture] is based around three primary components:
- The OTel ingester, officially called the SigNoz OTel Collector, which
  receives telemetry from OTel collectors and other programs via OTLP and
  writes the data to ClickHouse.
- A [ClickHouse] column-oriented DBMS, which stores time series and other
  data. (This may have replicas.)
- The SigNoz binary configures the OTel ingester, queries ClickHouse, and
  provides:
  - The _frontend,_ a Web UI built on the API server.
  - _API server,_ serving the frontend and independent clients.
  - _Ruler,_ which evaluates alert rules and sends alerts to Alertmanager.
  - _Alertmanager,_ handling deduplication, grouping and notification
    delivery.
  - _OpAMP_ which dynamically configures log pipelines in the ingester.
- The [docker-compose] gives more exact details about the architecture and
  configuration.

### Notes

> [!NOTE]
> The information below is mainly at the level of detailed use of SigNoz.
> There's considerably more going on under the hood (especially with
> time-series databases used by SigNoz, the OTel network protocol (OTLP)
> and feeders such as [`otelcol`])

> [!WARNING]
> This document was written with considerable AI assistance; it should be
> much more carefully checked before this notice is removed.


Data Types
----------

### Time Series and Metrics

SigNoz deals (sort of under the hood) in _samples_ that have a composite
name, a timestamp and a value. (OTel calls these _data points._)

The composite names consist of:
- A _metric_ name e.g. `system.cpu.utilization`.
- A set of _attributes_ that are name-value pairs e.g. `os.type=linux`,
  `host.name=foo.example.com`, `cpu=cpu0`, `state=user`.
- Temporality, if present (see below).

Internally in SigNoz the composite name is usually identified by a unique
_fingerprint._ The `deployment.environment` attribute, temporality, and
metric name may sometimes be redundantly stored alongside the fingerprint
to aid in indexing. E.g., the storage/sharding key is
(`deployment.environment` tag, temporality, metric_name, fingerprint).

A _time series_ is a series of (timestamp,value) pairs identified by a
composite name. A _metric_ is a set of time series with a common metric
name but varying attribute names and values. More often than not, multiple
time series that are technically distinct are aggregated and queried
together (GROUPed BY in RDBMS terminology): for example all
`host.name=foo.example.com` series regardless of the `host.function=…`
value or the `cpu=…` value. (When doing this, we use aggregation functions;
see the UI section below for details.)

A metric has one of the following [types][] (`time_series_v4.type`).
- Gauge: An instantaneous value, free to rise or fall (e.g., temperature).
  Has no temporality (`Unspecified`).
- Sum: A running total, with two independent properties:
  - Monotonicity:
    - `is_monotonic=true`: A _counter,_ resetting to 0 on restart. 'Rate'
      and 'Increase' temporal aggregation work only on this.
    - `is_monotonic=false`: Like a Gauge, but semantically can be added
      across labels, e.g. bytes of memory by `state=used|free|cached` (sum
      = total RAM), as opposed to temperature across several CPUs.
  - Temporality:
    - Cumulative: Reports the total since start.
   -  Delta: Change since the last report (cheaper to report).
- Histogram: a _set_ of series describing a distribution, not a single
  value—one `<name>_bucket{le=…}` series per bucket bound (count of
  observations ≤ that bound), plus `<name>_sum` and `<name>_count`. Carries
  `Cumulative` or `Delta` temporality.
- ExponentialHistogram: as Histogram, but with geometrically-growing bucket
  widths (set by a scale factor) to span a wide range compactly; stored in
  its own form rather than as `le` bucket series. Self-hosted SigNoz only
  (set `enable_exp_hist`), and SigNoz supports only `Delta` temporality.

By convention, all values in a metric have the same meaning (e.g., fraction
of CPU time, above), unit, range (`[0‥1]`, above), [type, temporality,
etc.][types], etc. This is not enforced in any way (i.e., values are never
rejected by SigNoz ingestion), but changes can cause various "interesting"
issues such as [metrics "vanishing"] or other query failures.

Metrics have descriptions that can be seen in the Metrics Explorer, but
attributes do not. You can view attribute names in a pop-up when you click
in the 'filter query' box in the Query Builder, and all values ever
received can be shown in the details of the metric in the Metrics Explorer.
(Clicking on the metric from the Metrics Summary page will reveal a drawer
menu that has an `Open in Explorer` button in the top right corner; next to
that there is sometimes a `lucide-crosshair` button that leads to the
`Metrics Explorer — Metrics Inspect` page which can show graphs of the
actual datapoints)

As an example, given the way the otelcol daemon is configured in one
example installation, the `system.cpu.utilization` metric has the following
attributes, which were determined by the otelcol configuration. (The
`processors.resourcedetection.detectors = ['system', …]` setting in the
config generates `host.name` and `os.type`; see the [`otelcol` `system`
documentation][ot-int-sys] for configuring this.)
- `cpu`: cpu0, cpu1, …
- `deployment.environment`: 'production' only
- `host.name`: …
- `os.type`: 'linux' only
- `state`: interrupt, nice, steal, softirq, wait, system, user, idle


Some notes related to OTel and other reporters:
- Resource attributes such as `host.name`, flattened in SigNoz, are not so
  flat in OTel: they separately identify the emitting tier. This OTel
  tiering is not discussed here since it's not really relevant to SigNoz.

### Traces

TBD.

### Logs

TBD.


User Interface
--------------

Core navigation is done from an expanding menu bar at the left, with:
- SigNoz icon and version number. (Version number may not be displayed; see
  [signoz#11602].)
- __Home:__ random stuff; not very useful.
- __Alerts:__ random stuff.
- __Dashboards:__ data displays and queries based on those.
- __Shortcuts:__ Services, Logs, Traces and Infrastructure, in
  user-configurable order.
  - __Infrastructure:__ Lists hosts and some CPU information. Click on a
    host to get a sidebar showing a default metrics display, logs, traces
    and soon containers and processes. (Note that these use AVG, not
    MAX/MIN, and so hide spikes.)
  - …
- __More__
  - __Metrics:__ The _Metrics Explorer,_ listing all metrics and attributes
    that have been received and direct views of received metrics. (The
    listing is paged with page size and number at the bottom of the screen.)
  - …

### Dashboards

The core user interface is a list of user-created _dashboards,_ each of
which contains one or more optional _sections,_ each of which contains one
or more _panels,_ which are graphical or textual displays of data. The
panel displays may be generated with the Query Builder, a raw ClickHouse
query or PromQL.

Dashboards may have a set of _variables_ configured under the "Configure"
button "{} Variables" tab. These will be displayed as entry boxes or
dropdowns at the top of the dashboard, allowing the user to customise the
panels based on those values. Typically this is used to set e.g.
`host.name` (referenced as `$host.name` in queries) to have the panels show
data for just a specific host.

#### Query Builder

A panel is generated with one or more _queries_ named `A`, `B`, … in order
and optionally formulae named `F1`, …. Each query and formula result may be
displayed or hidden; any query result can be used as input for a formula,
e.g. `100 - (A * 2)`. (Note that formulae are entirely different from the
"functions" below.)

The [query builder] has the following parameters for each query. Some
specific only to certain signals are marked with `(ₘₜₗ)` for
metrics/traces/logs.
* Display: on or off
* Name: automatically set by the system; `A`, `B`, … in order.
* Signal: Logs, Metrics or Traces.
* (ₘₗ)𝑓x: [Functions for Extended Data Analysis][func-ea]. Despite being
  above the aggregation sections, these are applied _after_ aggregation.
  (XXX this is unclear, and really needs to be tested and sorted out.)
* (ₘ)Source: select a single metric; all time series belonging to the
  metric will be processed by the query. The "Meter" section in the drop
  down is just an small set of metrics generated by SigNoz itself.
* Filter query: filters the data using [search syntax]. For metrics,
  generally comparisons of attribute values, e.g., `host.name IN $host.name
  AND state = idle`, where `$host.name` is a dashboard variable (see above).
* (ₘ)Aggregate _within_ time series: see below.
* (ₘ)Aggregate _across_ time series: see below.
* (ₜₗ)Count/Avg/etc.; Group By
* Having; Order By; Limit
* Legend format: use double-braces to enclose variables, e.g.,
  `{{host.name}}`.

__"Aggregate within time series"__ controls the bucketing of samples.
Bucketing is _always_ done, in part to keep query performance good.
Currently the minimum bucket size is 60 seconds; this will be lowered at
some point (see [signoz#7248]). The maximum number of buckets across the
displayed interval is 1500; the automatic default (which you usually want
to use) is around 300.

The aggregation is separate per time series: i.e., MAX, AVG whatever will
be applied separately to each `idle,cpu0`, `idle,cpu1`, `user,cpu0`,
`system,cpu0`, etc.

Since a bucket almost invariably contains multiple points, take care which
aggregation function you use to determine the single bucket value. If
you're looking for spikes, with AVG they will get lost if you zoom out; you
want to use MAX (or MIN) to use the _highest_ value in the bucketed range
as the bucket value instead.

__"Aggregate across time series"__ groups by the attributes in the `by […]`
box at the right and then applies the selected aggregation function to
combine the attributes _not_ grouped. E.g., if you group by `host.name`,
you will get separate outputs (and graph lines) for each host, but all the
`cpu` values `cpu0`, `cpu1`, … will be aggregated with the function. Click
in `by […]` box to see a pop-up of all remaining attributes on the data
point to which the 'across' aggregation is being applied.



<!-------------------------------------------------------------------->
[ClickHouse]: https://en.wikipedia.org/wiki/ClickHouse
[SigNoz]: https://signoz.io/docs/
[`otelcol`]: https://github.com/open-telemetry/opentelemetry-collector-contrib
[`signoz-otel-collector`]: https://github.com/SigNoz/signoz-otel-collector
[architecture]: https://signoz.io/docs/architecture/
[docker-compose]: https://github.com/SigNoz/signoz/blob/main/deploy/docker/docker-compose.yaml
[metrics "vanishing"]: https://signoz.io/docs/metrics-management/troubleshooting/faqs/
[types]: https://signoz.io/docs/metrics-management/types-and-aggregation/
[ot-int-sys]: https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/resourcedetectionprocessor/internal/system/documentation.md

<!-- Dashboards -->
[func-ea]: https://signoz.io/docs/querying/functions-extended-analysis/
[query builder]: https://signoz.io/docs/userguide/query-builder-v5/
[search syntax]: https://signoz.io/docs/userguide/search-syntax/

<!-- Issues, etc. -->
[signoz#11602]: https://github.com/SigNoz/signoz/issues/11602
[signoz#7248]: https://github.com/SigNoz/signoz/issues/7248
