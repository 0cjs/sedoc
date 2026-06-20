SigNoz OTel Collectors Information
==================================

Usually the OTel Collector SIG collectors ([`otelcol`],
[`otelcol-contrib`]) are used with SigNoz. The former includes the 'core'
set of collectors; the latter includes a bunch of popular additional ones.
There are even bigger collections of collectors elsewhere.

Collector Metric Definitions
----------------------------

Linux collectors read [`/proc/meminfo`]; the keys read from that are given
in parens below, where applicable.

* `system.memory.limit` (`MemTotal`): Total memory available to the system.
  Expected to be constant within a single boot.
* `system.memory.utilization`: The same attributes as `.usage` below, but
  as a fraction [0,1] of `.limit`.
* `system.memory.usage`: attribute values of `state`
  (†=reclaimable or unused pages that may be dropped to give memory to 'used'):
  -  `used`: Neither free nor cache: tracks workload. (More below.)
  - †`cached` (`Cached+SReclaimable`): FS file data blocks and other cache.
  - †`free` (`MemFree`): Entirely idle; expected to be near 0 because `cached`.
  - †`buffered` (`Buffers`): FS metadata etc. (not file data blocks!), small.
  -  `slab_unreclaimable` (`SUnreclaim`): kernel data, generally small.
  - †`slab_reclaimable` (`SReclaimable`):  kernel data, generally small.
  -  `inactive`: Never appears on Linux.

Current `otelcol-contrib` is version 0.144.0, but if you're using an
earlier version, you may get an older form of `.used`:
- < v0.137.0 : `Total - Free - Buffers - (Cached+SReclaimable)`
- ≥ v0.137.0 : `Total - MemAvailable` (closest to htop's "used")

All states together add to more than `.limit` because `used` includes
`slab_unreclaimable` and `cached` includes `slab_reclaimable`. This
doesn't matter that much; the TLDR is that you want `.used` to be _well_
under total/`.limit` so that caching is doing its work. So the key value is
really just `.used`, plus your common sense when looking at how much
headroom you have.

#### Optional Extras

Adding `metrics: {system.linux.memory.available: {enabled: true}}` to the
otelcol config will give you `system.linux.memory.available`, which is a
better measure of real 'headroom' (see [`/proc/meminfo`]). But on
≥`v0.137.0` you get this with `.limit` - `.used` anyway.



<!-------------------------------------------------------------------->
[`/proc/meminfo`]: https://www.kernel.org/doc/html/latest/filesystems/proc.html
[`otelcol-contrib`]: https://github.com/open-telemetry/opentelemetry-collector-contrib/
[`otelcol`]: https://github.com/open-telemetry/opentelemetry-collector/
