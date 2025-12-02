GitHub - Tips and Tricks
========================

* [General](hub-general.md) | [Workflows](hub-workflows.md)
  | [Tips](hub-tips.md)
  |

URLs to Display Public Keys
---------------------------

- SSH public keys: <https://github.com/0cjs.keys>
  - (May strip key comment?)
- PGP public keys:  <https://github.com/0cjs.gpg>


Invisible Unread Notifications
------------------------------

There's a bug in GitHub that doesn't allow you to see some new
notifications, causing you to have a [permeanent unread notifications
indicator][cd#176236]. (In the notifications screen, it will show "1-0 of
1" notifications.)

* A [response from GitHub support][cd#6874a] shows how to use the [Mark
  notifications as read API][api-mnr] to mark all notifications as read.

* [This bookmark][cd#6874b] can be added to your browser to clear all
  notifications; paste the given code in the URL field.

* This can be [run from the browser console][cd#176236a]; open it, paste it
  and, if necessary, type `allow pasting` and re-paste it. (It may need to
  be run several times.)

    (function(){var f=document.querySelector('.js-notifications-mark-all-actions form[action="/notifications/beta/mark"]');if(f){fetch(f.action,{method:f.method,body:new FormData(f),credentials:"include"}).then(r=>{if(r.ok)setTimeout(()=>location.reload(),500);});}})();

[cd#176236]: https://github.com/orgs/community/discussions/176236
[cd#6874a]: https://github.com/orgs/community/discussions/6874?utm_source=chatgpt.com#discussioncomment-2859125
[api-mnr]: https://docs.github.com/en/rest/activity/notifications?apiVersion=2022-11-28#mark-notifications-as-read
[cd#6874b]: https://github.com/orgs/community/discussions/6874#discussioncomment-14538058
[cd#176236a]: https://github.com/orgs/community/discussions/176236#discussioncomment-14716796
