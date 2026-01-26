[Amazon Web Services][AWS]
==========================

* [Instance Metadata via HTTP](instance-metadata.md)
* [Command Line Interface](cli.md)
* [CLI Command Reference](cli-commands.md)
* [IAM - Identity and Access Management](iam.md)
* [EC2 - Elastic Compute Cloud virtual server instances](ec2.md)
  (Includes Elastic IP and Public IP information.)
* [Lambda - Serverless Compute](lambda.md)

The on-line user guide pages are generated from markdown files in GitHub
project [`awsdocs/amazon-ec2-user-guide`][gh awsdoc]; they accept issues
and pull requests.

Overall Structure:
* World is divided into [_regions_][reg-az] (`us-east-1` Virgina,
  `us-east-2` Ohio, etc.) which are totally independent, through
  cross-region traffic is cheaper than external traffic. Regions may be
  individually enabled/disabled per account.
* Each region has a set of [_availability zones_][reg-az].
  - The specific physical locations are identified with [_AZ IDs_][az-list]
    such as `use1-az1` in `us-east-1`. These are consistent across all
    accounts and rarely used.
  - For pre-2025 accounts using pre-2012 regions , each account has its own
    mapping of _AZ Names_ to AZ IDs; the name is the region name w/`a`,
    `b`, etc. appended; [after this it's uniform][AZ-IDs]. Thus pre-2012
    `us-east-1a` in one account might be the same physical AZ `us-east-1b`
    in a different account. These are what's normally used in the console
    and APIs.
* Within a region you create one or more _Virtual Private Cloud_ ([VPC])
  entities. Each has a separate subnet for each AZ in the region; each
  resource (for the most part) is placed in one of these subnets.

### General Notes

[Key Pairs]:
- Always SSH keypairs: ED25519 (not for Windows), SSH-2 RSA (AWS generates
  2048 bit; can use 1024/2048/4096 bit, but not 1024 bit for EC2 Instance
  Connect API). DSA not supported.
- File formats: `authorized_keys`, PEM private key files, Base64-encoded
  DER (RSA only), RFC 4716 SSH public key format.
- Limit of 5000 keypairs per region.
- AWS can create the private key and let you download it (it doesn't keep a
  copy) or you can upload a public key.
- Add keypair from [EC2 console] » Key Pairs (left pane) » Import
- Public key used at EC2 creation can be retrieved from instance metadata.

Region notes:
- Most useful [regions][aws-regions]: `us-east-1` (N. Virginia),
  `us-east-2` (Ohio), `ap-northeast-1` (Tokyo; `-2` Seoul, `-3` Osaka).
- Select region using drop-down in top bar; if creating an EC2 instance or
  whatever this will reset any partial configuration.



<!-------------------------------------------------------------------->
[AWS]: https://en.wikipedia.org/wiki/Amazon_Web_Services
[AZ-IDs]: https://docs.aws.amazon.com/global-infrastructure/latest/regions/az-ids.html
[EC2 console]: https://console.aws.amazon.com/ec2/
[VPC]: https://docs.aws.amazon.com/vpc/latest/userguide/
[aws-regions]: https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html
[az-list]: https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-availability-zones.html
[gh awsdoc]: https://github.com/awsdocs/amazon-ec2-user-guide
[key pairs]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
[reg-az]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
