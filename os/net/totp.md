TOTP (HTOP, 2FA)
================

The Debian `oathtool` package provides [oath-toolkit] including the
`oathtool` command-line client for generating TOTP responses.

Given a key in the base-32 8-groups-4-chars format, you can generate a
TOTP response for the current time with:

    oathtool --totp -b 'abc2 def3 ghj4 klm5 npq6 rst7 uvw8 xyz9'

Add `-v` to get the exact parameters it used to generate the code.



<!-------------------------------------------------------------------->
[oath-toolkit]: http://www.nongnu.org/oath-toolkit
