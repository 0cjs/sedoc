Instance Metadata via HTTP
==========================

EC2 hosts may access their [instance metadata] via unauthenticated
HTTP connections to `http://169.254.169.254`, returning data as
content type `text/plain`. Responses from the server do not include a
trailing newline; using `curl -w\\n` will add one.

There are also some tools available to help with queries:
* `ec2-metadata`, Amazon's [Instance Metadata Query Tool][imqt] (Bash).
  Download link: <http://s3.amazonaws.com/ec2metadata/ec2-metadata>.
* `ec2metadata` from the Debian `cloud-guest-utils` package (Python 2).


URLs
----

Paths ending in `/` produce a listing of objects below them, with
prefixes of further sub-objects ending in `/`. In some circumstances
the object name may be followed by `=` and more information, e.g., for
`public-keys/`.

The top-level under `169.256.169.254` appears to select the version of
the API, `latest/`, `1.0/` or dates ranging from `2007-01-19/` to
`2018-03-28/`. Below that are `user-data/` (see below), `meta-data`
and, in newer API versions, `dynamic/`. Amazon documentation indicates
the following prefix for metadata queries, which is the assuemd prefix
for the rest of this section:

    http://169.254.169.254/latest/meta-data/

This is a subset of useful queries; for a larger list see [Instance
Metadata Categories][mdcat].

- `instance-type`
- `ami-id`: The image ID used to build the instance. when launching
  multiple instances from one command.
- `iam/info`: JSON object including the `InstanceProfileArn`.
- `iam/security-credentials/`: JSON object for each role including
  `AccessKeyId`, `SecretAccessKey` and `Token`.
- `ami-launch-index`: The order in which the instance was launched
- `local-ipv4`
- `public-ipv4`
- `public-keys/0/openssh-key`: SSH public key configured for the instance.


User Data
---------

EC2 instances may be configured with an opaque [user data] object of
up to 16 KB before base64 encoding. This must be base64-encoded (done
by the user or by the console). When returned from the web query it
will have been decoded.



[instance metadata]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
[imqt]: https://aws.amazon.com/code/ec2-instance-metadata-query-tool/
[user data]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html#instancedata-add-user-data
[mdcat]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html?shortFooter=true#instancedata-data-categories
