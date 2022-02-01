[Amazon Web Services][AWS]
==========================

* [Instance Metadata via HTTP](instance-metadata.md)
* [Command Line Interface](cli.md)
* [CLI Command Reference](cli-commands.md)
* [IAM - Identity and Access Management](iam.md)
* [EC2 - Elastic Compute Cloud virtual server instances](ec2.md)
* [Lambda - Serverless Compute](lambda.md)


Misc Notes:
- [Availability zones][reg-az] are arbitrarily mapped for each account.
   E.g., `ap-northeast-1a` in one account might be the same zone as
  `ap-northeast-1b` in a different account, and might not exist at all
  in a third account.

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

Per [Regions and Zones][reg-az]:
- Regions are, e.g., `us-east-1` (N. Virginia), `us-east-2` (Ohio),
  `ap-northeast-1` (Tokyo; `-2` Seoul, `-3` Osaka).
- Select region using drop-down in top bar; if creating an EC2 instance or
  whatever this will reset any partial configuration.



<!-------------------------------------------------------------------->
[AWS]: https://en.wikipedia.org/wiki/Amazon_Web_Services
[reg-az]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
[key pairs]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
[EC2 console]: https://console.aws.amazon.com/ec2/
