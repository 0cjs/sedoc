GitLab
======

* [GitLab](gitlab.md) | [GitLab CI](gitlab-ci.md)
  | [GitLab Runner](gitlab-runner.md)

[GitLab] is much like GitHub with a poorer UI but some extra features that
GitHub doesn't have. Main selling point over GitHub Enterprise is a
free ("Community") version you can [install] on your own servers. They
have official Docker images which may be the easiest way to use it.
(Not clear if these include the DBMS or rely on an existing one in the OS.)

Other documents related to this:
* [Git/GitLab](../git/gitlab.md): GitLab's configuration and use of
  its hosted Git repos.
* [GitLab CI/CD](gitlab-ci.md): How to set up a repo and its
  `.gitlab-ci.yml` file for automated building by a runner.
* [GitLab Runner](gitlab-runner.md): GitLab's runner for the
  build ("CI/CD") system described below.


Authentication
--------------

GitLab accounts are identified by the _username_, _email address_ or
SSH public key; each must be a unique on the GitLab instance.
Usernames cannot be changed by users, only by admins. (Users can
change their email addresses and SSH keys, though duplicates will not
be allowed.) The _name_ (also user settable, usually the full name of
the user) is used for display within the web interface, but externally
(e.g., in URLs) the username is used.

### SSH Keys

"[Deploy keys]" (SSH public keys) giving read-only or read-write
access to all or specific projects may also be added. These are
silently associated with the account that added the key; this is not
displayed in the interface. Actions such as sending email on failures
of pipelines triggered by that key will use the address set for that
account.

### Access Tokens

If not using a session cookie, [personal access tokens] can be used to
authenticate to the API and Git over HTTP. (A PAT is required if for
these types of access if 2FA is enabled.) Users may have as many of
these as they need, and may expire them by hand or set an expiry date.

It's not clear how tokens are created for services not associated with
a user.

Access tokens have various [scopes]:
* `api` (≥8.15): Complete read-write API access; HTTP fetch for Git repos
  (token required when 2FA enabled)
* `read_user` (≥8.15): Read-only for HTTP `/users` API
* `read_registry` (≥9.3): Can read [container registry] images in
  private projects where auth required
* `sudo` (≥10.2): Allow API actions as any user if authenticated user
  is admin

#### Impersonation Tokens

Sysadmins may create [impersonation tokens] for users that function in
the same way as the user's own tokens. (The user will not see these in
her list of tokens.) Admin accounts using the API may also use [sudo]
access for individual requests take actions as another user using
their own access token.


GitLab API
----------

GitLab offers a [REST API][api] in two major versions; V4 is preferred
since GitLab 9.0. V3 was deprecated in 9.5 and removed in 11.0. New
features may be added to a version without a version number change.
The API is moving toward [GraphQL], but that's currently alpha; it
will be versionless and co-exist with V4 (or V5, which would be a
compatibility layer).

Authentication information is passed in via an HTTP header or URL
query parameter. (Unauthenticated requests will fail or return only
public data.) Methods are:
1. Personal Access Tokens (`Private-token:`, `private_token=`)
   generated as described above.
2. OAuth2 tokens (`Authorization:`, `access_token=`).
3. Session cookie `_gitlab_session` set at login to the web UI.
4. [RFC-7644][] (cross-domain HTTP auth) provided in GitLab Silver and
   above via the [SCIM API].

Examples of personal access tokens used with `curl`. Use `-L` to
follow redirects and `--header` to ensure subsequent requests include
the token if using URLs like well-known URLs for build artifact
download.

    curl https://gitlab.example.com/api/v4/projects?private_token=9koXpg98eAheJpvBs5tK
    curl -L --header "Private-Token: 9koXpg98eAheJpvBs5tK" \
        https://gitlab.example.com/api/v4/projects

### API Subgroups

The [services API] configures GitLab's integrations with other
services, such as pipeline-emails, Kubernetes, JIRA, and Slack
notifications. It requires a token with Maintainer or owner
permissions.



<!-------------------------------------------------------------------->
[GraphQL]: https://docs.gitlab.com/ce/api/graphql/index.html
[RFC-7644]: https://tools.ietf.org/html/rfc7644
[SCIM API]: https://docs.gitlab.com/ce/api/scim.html
[api]: https://docs.gitlab.com/ce/api/README.html
[deploy keys]: https://docs.gitlab.com/ce/ssh/README.html#deploy-keys
[impersonation tokens]: https://docs.gitlab.com/ce/api/README.html#impersonation-tokens
[personal access tokens]: https://docs.gitlab.com/ce/api/README.html#personal-access-tokens
[scopes]: https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#limiting-scopes-of-a-personal-access-token
[services api]: https://docs.gitlab.com/ce/api/services.html
[sudo]: https://docs.gitlab.com/ce/api/README.html#sudo
