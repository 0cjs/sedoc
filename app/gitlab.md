[GitLab]
========

Much like GitHub, UI isn't as good, but does have some features that
GitHub doesn't have. Main selling point over GitHub Enterprise is a
free ("Community") version you can [install] on your own servers. They
have official Docker images which may be the easiest way to use it.
(Not clear if these include the DBMS or rely on an existing one in the OS.)


[GitLab CI]
-----------

You specify build descriptions in [`.gitlab-ci.yml`]; [runners] will
then pick up jobs and execute them.

The [Autoscale GitLab CI runners][aws-autoscale] describes how to configure
a system that can spin up and down EC2 instances as the load varies.



[GitLab CI]: https://docs.gitlab.com/ee/ci/README.html
[GitLab]: https://gitlab.com
[`.gitlab-ci.yml`]: https://docs.gitlab.com/ee/ci/yaml/README.html
[aws-autoscale]: https://substrakthealth.com/news/gitlab-ci-cost-savings/
[install]: https://about.gitlab.com/installation/
[runners]: https://docs.gitlab.com/ee/ci/runners/README.html
