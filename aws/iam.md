AWS Identity and Access Management (IAM)
========================================

AWS authentication and authorization is done via the [Identity and
Access Management (IAM)][IAM] system, which includes the Security
Token Service (STS).

The term _account_ below refers to an 'AWS account' which is a
single administrative entity (with a _root login_) containing all IAM
users and other resources. The account is identified with a nine-digit
account number and may also have an optional _account alias_, a unique
(within worldwide AWS account aliases) name to more easily identify
the account.


Identities and Authentication
-----------------------------

Each [_identity_][identities] is a single _user_ or _role_. This is
sometimes called a [_principal_] though in AWS that seems to refer to
external identities that have assumed a role via [federation], as well.

An [IAM user] is typically associated with a person and may use
various forms of authentication based on _credentials_ associated with
the account, including:
* Shared secret (passwords, [access keys])
* X.509 certificate (not all services)
* SSH public key (CodeComit only)
* TOTP token (which AWS calls Multi-Factor Authentication or MFA)
* External identity providers (SAML, Active Directory, etc.)
* Web identity providers ([AWS Cognito], OpenID Connect, Google,
  Facebook, etc.)

Each account has a specially privileged _root user_ which should not
be used for anything except to set up one or more IAM users with admin
privs.

An [IAM role] is like a user without authentication credentials. (This
is different from some other systems where "roles" are the equivalent
of _groups_, below.) Because roles are often shared, sessions have
both RoleName and a RoleSessionName; the latter is intended to
identify the principal (within AWS or outside it) that used the role
in that session.

Roles can be assumed under the conditions described in the role's
`AssumeRolePolicyDocument`, which typically restricts the principals
that can assume the role and perhaps requires MFA (but can have nearly
arbitrary other restrictions as well). A role is assumed in one of the
following ways:
* Assigned to an AWS host or service via configuration, e.g., [EC2
  instance profiles]
* Explicitly assumed (e.g., via [CLI][cli-roles]) by an IAM user with
  a policy that allows that (the session is time-limited and the original
  user's access permissions are unavailable while the role is assumed)
* Authentication via [temporary security credentials][tempcred]
* Used for accounts on third-party identity providers and
  authenticated by them rather than AWS (federated users)

The User Guide's [Identities] section describes when you should create
a user vs. a role.

Note that you cannot prevent anybody, anywhere in the world,
authenticating as an IAM user via the AWS API. However, you can write
policies (see below) that restrict, e.g., the IP addresses authorized
to perform requests after authentication.

### Console (Web) Access

The web-based AWS [console] offers login for IAM users at the
following URLs. (These will sign out any existing session.)

    #   Generic login page; requires account ID/alias entry
    https://console.aws.amazon.com
    #   You can include the account ID or alias in the URL
    #   This will immediately sign out any existing session.
    https://ACCOUNT.signin.aws.amazon.com/console/

Root user login is a separate page accessed via a link from the IAM
login page above.


Authorization/Access Control
-----------------------------

Access to resources is described in [_policies_][policy]; the access
granted to an identity is is the union of the policies assigned
directly to the the identity and all [_groups_] of which the identity
is a member.

Policies come in several forms:
* Identity-based policies: attached to an identity or group
  * Managed Policies that can be attached to multiple
    users/roles/groups
    - AWS managed policies: read-only, supplied and maintained by Amazon
    - Customer managed policies: configured/maintained by the customer
  * Inline policies: embedded directly into a single user/role/group
  * Policies supplied to the `AssumeRole` API call to further restrict
    what can be done during that session ([Permissions for AssumeRole
    APIs][assumerole-perms])
* [Resource-based policies]: attached to a resource specifying what
  various principals can do with the resource



[AWS Cognito]: http://docs.aws.amazon.com/cognito/devguide/
[AWS]: https://en.wikipedia.org/wiki/Amazon_Web_Services
[EC2 instance profiles]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html
[IAM role]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
[IAM user]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
[IAM]: https://aws.amazon.com/iam/
[_groups_]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html
[_principal_]: https://en.wikipedia.org/wiki/Principal_(computer_security)
[access keys]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
[assumerole-perms]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_control-access_assumerole.html
[cli-roles]: https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html
[console]: https://docs.aws.amazon.com/IAM/latest/UserGuide/console.html
[federation]: https://en.wikipedia.org/wiki/Federated_identity
[identities]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id.html
[policy]: https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_access-management.html
[resource-based policies]: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_identity-vs-resource.html
[tempcred]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_request.html
