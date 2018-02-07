AWS CLI Notes
=============

These cover the [`aws` command-line program][aws-cli].
The [reference] lists all options and commands.

Installation
------------

`aws` is a Python package (2.6.5+ or 3.3+) available from PyPI:

    pip3 install --user --upgrade awscli

This can be installed in a virtual environment as well, and there are
also standalone installers for all platforms (Linux, MacOS, Windows).
See [aws-install] for more information.


CLI Authentication on EC2 Instances
-----------------------------------

Best practice when using the AWS CLI tool on an EC2 instance is to use
the [instance profile][instprof] (an [EC2 IAM role]) for the host by
default, and use your own personal [access credentials][creds] only
when you explicitly ask to do so.

#### Checking the Instance Profile

You can confirm the instance profile assigned to the host with:

    $ curl http://169.254.169.254/latest/meta-data/iam/info; echo
    {
      "Code" : "Success",
      "LastUpdated" : "2017-11-02T04:34:19Z",
      "InstanceProfileArn" : "arn:aws:iam::012301201230:instance-profile/AHostRole",
      "InstanceProfileId" : "AAAAAAAAAAAAAAAAAAAAA"
    }

(This will return a 404 if there is no instance profile assigned to
the host.)

#### Configuring AWS Command Line Tool Profiles

To configure the aws command line tool, ensure the default command
line tool profile has no access key, and you have a separate profile
with your own access key, e.g.:

    # ~/.aws/config
    [default]
    region = ap-northeast-1
    [profile admin]
    region = ap-northeast-1

    # ~/.aws/credentials
    [default]
    [admin]
    aws_access_key_id = AKIAIOSFODNN7EXAMPLE
    aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

(Profiles are most easily configured with `aws configure --profile PROFNAME`.)

#### Usage

Setting the `AWS_PROFILE` environment variable or providing the
`--profile PROFNAME` option to `aws` determines the profile you use.
If neither is set, profile `default` will be used.

To verify you're configured correctly:

    $ unset AWS_PROFILE
    $ aws sts get-caller-identity
    {
        "Arn": "arn:aws:sts::012301201230:assumed-role/AHostRole/i-12345678
        "UserId": "AAAAAAAAAAAAAAAAAAAAA:i-12345678"
        "Account": "012301201230",
    }
    $ AWS_PROFILE=admin aws sts get-caller-identity
    {
        "Arn": "arn:aws:iam::012301201230:user/aws_m4st3r_user
        "UserId": "BBBBBBBBBBBBBBBBBBBBB:i-11111111"
        "Account": "012301201230",
    }



[EC2 IAM Role]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html
[aws-cli]: https://aws.amazon.com/cli/
[aws-install]: https://docs.aws.amazon.com/cli/latest/userguide/installing.html
[creds]: https://docs.aws.amazon.com/general/latest/gr/aws-security-credentials.html
[instprof]: http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html
[reference]: https://docs.aws.amazon.com/cli/latest/reference/
