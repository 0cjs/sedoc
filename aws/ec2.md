AWS EC2 (Elastic Compute Cloud)
===============================

* [General EC2 Documentation][ec2doc]
* [User Guide for Linux Instances][ug-linux]
* [FAQ]


Instance Type Information
-------------------------

[EC2Instances.info][ec2info] contains a database of EC2 instance type
information parameters (CPU, storage, cost, etc.) scraped from various
Amazon pages.

It can be queried in tabular format on the site or the full database
can be downloaded from the [site source repo][ec2source] as a 4 MB
[JSON file][ec2json]. (There's also [RDS instance info][ec2rds]
available.)

It's useful to query with [`jq`]:

    wget https://raw.githubusercontent.com/powdahound/ec2instances.info/master/www/instances.json
    jq -c '.[] | [ .instance_type, .vCPU ]' instances.json
    jq -r '.[] | "\(.vCPU)\t\(.instance_type)"' instances.json | sort -n


[Pricing]
---------

### [Purchasing Options][ec2purch]

* [On Demand] ([demand-price]): Fixed cost billed per-second (60-second minimum)
* [Spot Instances] ([spot-price]): Market for temporary use of unused instances
* [Reservations] ("Reserved Instances"):
  Reduced billing for commitments to specific use patterns
* [Scheduled Instances]: Reduced billing for use in specific time windows
* Dedicated Hosts and Instances: single-tenant hardware; see below.

The instance description for a running instance tells you the
lifecycle (`normal`, `spot`, `scheduled`) and tenancy (see below).

### [Spot Instances]

In the spot instance market you place a limit order bid on specific
instance types. When a requested instance is available at or below
your bid it will be started; as the market changes you may be given a
two-minute notice of termination. (There also seem to be 1- and 6-hour
defined durations.) Helpful tools include the [Spot Instance Pricing
History][spot-price-hist] and the [Spot Bid Advisor][spot-bidadv].

Prices can vary dramatically across AZs in the same region,
particularly when a customer is requesting a large number of
instances. E.g., as of this writing the prices of Linux instances in
Tokyo are:

    $ 5.8800    c4.2xlarge  spot: ap-northeast-1a
    $ 0.5040    c4.2xlarge  on-demand
    $ 0.1204    c4.2xlarge  spot: ap-northeast-1c

    $11.7600    c4.4xlarge  spot: ap-northeast-1a
    $ 1.0080    c4.4xlarge  on-demand
    $ 0.1861    c4.4xlarge  spot: ap-northeast-1c

    $ 2.0160    c4.8xlarge  on-demand
    $ 0.7445    c4.8xlarge  spot: ap-northeast-1a
    $ 0.6362    c4.8xlarge  spot: ap-northeast-1c

If you can accept spot instances with different instance types and/or
from different availability zones, you can use [Spot Fleet] to set up
pool specifications and using a lowest price or diversified allocation
strategy take spot instances from the best pool with available
instances. It also tries to maintain the size of your fleet as you
lose instances.

### [Reservations] ("Reserved Instances")

Reservations, which Amazon slightly misleadingly calls "Reserved
Instances" are not associated with specific instances but are a
billing discount applied to use of on-demand instances that match
specific attributes. You pay for the reservation even when no
instances match it (and thus you're not receiving the discount). You
also get a capacity reservation when buying AZ-scope reserved
instances.

#### Reservation Characteristics

The price will depend on which characteristics you choose:

* Payment options: no upfront, partial upfront, full upfront.
* Term: 1 year (365\*86400s), 3 years (3\*365\*86400s)
* Class: standard (can be sold in marketplace), convertable (can be [exchanged])
* Instance Type (e.g., m4.large)
* Scope: region, availability zone (only AZ provides capacity reservation)
* Tenancy: shared, dedicated
* Platform: Linux/Unix, Windows, etc.

#### [How Reservations are Applied][ri-application]

AZ reservations apply only to the exact instance type and size
specified. Regional reservations can [apply to different sizes in an
instance type][ri-apply-r]. E.g., a regional 4xlarge reservation can
discount two 2xlarge instances or 1/2 of an 8xlarge instance. The
[Cost and Usage Report][cu-report] can give exact details.

Using regional reservations of the same size can help to save
reservation slots (see "Reservation Limits" below). You can replace
2 * 2xlarge and 1 * 4xlarge reservations, using two reservation slots,
with one 2 * 4xlarge reservation, using only a single slot.

A reservation discounts 3600 seconds of instance use per clock hour,
whether serial or concurrent. E.g., an m4.xlarge reservation will give
1-instance-hour discount from 13:00-14:00 whether applied to a single
m4.xlarge instance running for the full hour or four m4.xlarge
instances running from 13:00-13:15.

Multiple AWS accounts [consolidated][orgs-intro] to one billing
account share the reservations in all accounts across all accounts:
all instance costs are calculated and summed to the billing account,
and then all reservations are applied to discount that sum.

Discount pricing tiers are available for reserved instances in a
region: billings over $500K are discounted 5% and over $4M, 10%.
Consolidated billing applies. Tiers do not apply to convertable
reservations, MS SQL Server reservations, or reservations purchased
from third-party sellers or the marketplace. There's more complexity;
see the docs for details.

#### Reservation Renewals and Changes

Reservations are not renewed automatically; when they expire or are
sold your instances continue to run without the discount.

Reservations cannot be canceled but in some cases can be [modified] or
[exchanged].

There is an [RI Marketplace] for buying and selling reservations. (You
continue to reserve discounts for reservations posted for sale until
they are sold.) The RI Marketplace charges a 12% fee to sellers,
requires seller registration, and cannot sell reservations owned less
than 30 days or convertable reservations, among other restrictions.

#### Reservation Limits

The default limits for reservations are 20 reservation purchaes per
month per AZ plus 20 reservation purchaes per month per region. (These
limits can be increased by request.) You can always start an instance
corresponding to a currently unused AZ reservation even if this would
make you exceed your on-demand instance limit for the region.

#### Reservation Risks

No refund is given against reservations when the instance price drops.
AWS has had over 60 price reductions since it started. A typical price
drop is 7%.

Unless you bought convertable reservations, you can't move up to newer
hardware (e.g., `c3` to `c4`) on current reservations. New generations
may or may not have a performance increase, but they may be
considerably cheaper than previous generations. Compare (ECU is
compute units, Mem in GB):

    Type        ECU Mem Demand  Reserved
    c3.4xlarge  55  30  $0.840  $0.584
    c4.4xlarge  62  30  $0.796  $0.504
    c5.4xlarge  62  32  $0.680  $0.428

Spot instances do not use reservation discounts so if you are saving
money by buying spot instances over on-demand instances when cheaper
spot instances are available you may end up with unused reservations
that you're still paying for.

Other analyses:

* The HFT Guy's [article][hft-pricing] comparing GCP and AWS pricing
  also discusses why AWS reserved instances can often be a bad deal.
* Infoworld's [Cloud pricing comparison][iw-cpc] offers good
  information on analyzing commitment discounts on the big three cloud
  providers.
* Cloudyn's older [EC2 price drops analysis][cloudyn-drop] provides a
  bit of historical information, a simple analysis (with spreadsheet)
  is shown in [a blog post][cloudyn-res] and they are one of several
  providers of systems to help analyze and optimize usage.

### [Scheduled Instances]

Scheduled Instances are 1-year capacity reservations recurring
daily/weekly/monthly with a specified start time and duration. (The
total yearly duration must be at least 1200 hours, avg 3.28
hours/day.) Typical use would be applications that run during business
hours or large batch jobs that run once a week/month.

Scheduled instances appear not to be available in all zones, and are
not available in Tokyo. For daily repeats in N. Virginia, the prices
appear to be very little (7%) lower than on-demand prices so the
main purpose for this seems to be capacity reservation. However, the
number of instances available is also fairly low (10-50).

Scheduled instances are launched with a special command. AWS uses a
[service-linked role] `AWSServiceRoleForEC2ScheduledInstances` to add
system tags to scheduled instances and terminate them. This can safely
be deleted if if you have no scheduled instances; it will be recreated
when you next purchase one.

### Dedicated Hosts and Instances

These allow you to allocate specific hardware on which to run
instances separate from the general hardware pool used by all
customers. This can be used to:

* Handle license systems that bind licenses to specific CPUs or cores.
* Ensure that hosting hardware is available regardless of demands by
  other customers.
* Ensure that other tenants are not running on your VM host hardware
  for security, audit or other reasons.

[Dedicated Instances] run on single-tenant hardware that's allocated
at instance creation time. (If not available, instance creation will
fail. Purchase dedicated reserved instances, which are separate from
regular reserved instances, to ensure a minimum amount of dedicated
hosting for VMs is available. You can also purchase dedicated spot
instances.) AWS decides which particular host an instance will run on.

[Dedicated Hosts] ([pricing][dh-pricing]) run a specific instance type
and allow you to manage precisely how instances are allocated onto
hosts. You pay for whole host, regardless of which or how many
instances you choose to run on it. Instances on dedicated hosts are
not applied to or restricted by account instance limits.

EBS never runs on single-tenant hardware; other services vary.
Reservations and spot pricing with dedicated instances are complex;
see the docs for details.

#### Tenancy

The instance description tenancy field will be:
* 'default': running on multi-tentant hardware, cannot be changed
* 'dedicated' instances on single-tenant hardware, can be changed to `host`
* 'host' instance on dedicated host; can be changed to `dedicated`

VPC default tenancy setting for new instances is:
* `default`: multi-tenant hosting unless specified otherwise.
  Cannot be changed for existing VPC.
* `dedicated`: dedicated unless `host` is specified; `default` cannot
  be used. Existing VPCs can be changed to `default`.


Instantiation Limits
--------------------

Instantiation of hosts is limited by both account limits and
availability of resources within the particular [availability zone].
(AZs often have only hundreds, not thousands, of free instances
available.) Instances on dedicated hosts are not restricted by or
included in these limits.

Account Limits:

* [Documentation][ec2lim-doc]
* EC2 resource limits: [default][ec2lim-res], [account][ec2lim-console]
* EC2 instance Limits: [default][ec2lim-inst], [account][ec2lim-console]

A request for a limit increase must go through a human and generally
takes at least a day.



[Dedicated Hosts]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-hosts-overview.html
[Dedicated Instances]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-instance.html
[FAQ]: https://aws.amazon.com/ec2/faqs/
[On Demand]: https://aws.amazon.com/ec2/pricing/on-demand/
[Pricing]: https://aws.amazon.com/ec2/pricing/
[RI Marketplace]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ri-market-general.html
[Reservations]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-reserved-instances.html
[Scheduled Instances]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-scheduled-instances.html
[Spot Fleet]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-fleet.html
[Spot Instances]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html
[`jq`]: ../lang/jq.md
[availability zone]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
[cloudyn-drop]: https://www.cloudyn.com/blog/analyzing-aws-ec2-price-drops-over-the-past-5-years/
[cloudyn-res]: https://www.cloudyn.com/blog/deciding-an-approach-to-the-cloud-aws-reserved-instances/
[cu-report]: http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-reports-costusage.html
[dh-pricing]: https://aws.amazon.com/ec2/dedicated-hosts/pricing/
[ec2doc]: https://aws.amazon.com/documentation/ec2/
[ec2info]: https://ec2instances.info
[ec2json]: https://raw.githubusercontent.com/powdahound/ec2instances.info/master/www/instances.json
[ec2lim-console]: https://ap-northeast-1.console.aws.amazon.com/ec2/v2/home#Limits:
[ec2lim-doc]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-resource-limits.html
[ec2lim-inst]: https://aws.amazon.com/ec2/faqs/#How_many_instances_can_I_run_in_Amazon_EC2
[ec2lim-res]: http://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html#limits_ec2
[ec2purch]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-purchasing-options.html
[ec2rds]: https://raw.githubusercontent.com/powdahound/ec2instances.info/master/www/rds/instances.json
[ec2source]: https://github.com/powdahound/ec2instances.info
[exchanged]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ri-convertible-exchange.html
[hft-pricing]: https://thehftguy.com/2016/11/18/google-cloud-is-50-cheaper-than-aws/
[iw-cpc]: https://www.infoworld.com/article/3237566/cloud-computing/cloud-pricing-comparison-aws-vs-azure-vs-google-vs-ibm.html
[modified]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ri-modifying.html
[orgs-intro]: http://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html
[ri-application]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts-reserved-instances-application.html
[ri-apply-r]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/apply_ri.html#apply-regional-ri
[ri-apply]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/apply_ri.html
[service-linked role]: http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms-and-concepts.html#iam-term-service-linked-role
[spot-bidadv]: https://aws.amazon.com/ec2/spot/bid-advisor/
[spot-price-hist]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances-history.html
[spot-price]: https://aws.amazon.com/ec2/spot/pricing/
[ug-linux]: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html
