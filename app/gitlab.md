[GitLab]
========

Much like GitHub, UI isn't as good, but does have some features that
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

#### SSH Keys

"[Deploy keys]" (SSH public keys) giving read-only or read-write
access to all or specific projects may also be added; these are not
associated with an account but are designed for use by applications.

#### Access Tokens

If not using a session cookie, [personal access tokens] can be used to
authenticate to the API and Git over HTTP. (A PAT is required if for
these types of access if 2FA is enabled.) Users may have as many of
these as they need, and may expire them by hand or set an expiry date.

Sysadmins may create [impersonation tokens] for arbitrary users that
function in the same way. Admin accounts may also use [sudo] access
against the API to take actions as another user.

It's not clear how tokens are created for services not associated with
a user, but perhaps the [services api] would have some clues.

Examples of use:

    curl https://gitlab.example.com/api/v4/projects?private_token=9koXpg98eAheJpvBs5tK
    curl --header "Private-Token: 9koXpg98eAheJpvBs5tK" \
        https://gitlab.example.com/api/v4/projects



[deploy keys]: https://docs.gitlab.com/ce/ssh/README.html#deploy-keys
[impersonation tokens]: https://docs.gitlab.com/ce/api/README.html#impersonation-tokens
[personal access tokens]: https://docs.gitlab.com/ce/api/README.html#personal-access-tokens
[services api]: https://docs.gitlab.com/ce/api/services.html
[sudo]: https://docs.gitlab.com/ce/api/README.html#sudo
