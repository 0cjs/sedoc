AWS Information
===============

AWS Instance Type Information
-----------------------------

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



[`jq`]: ../lang/jq.md
[ec2info]: https://ec2instances.info
[ec2source]: https://github.com/powdahound/ec2instances.info
[ec2json]: https://raw.githubusercontent.com/powdahound/ec2instances.info/master/www/instances.json
[ec2rds]: https://raw.githubusercontent.com/powdahound/ec2instances.info/master/www/rds/instances.json
