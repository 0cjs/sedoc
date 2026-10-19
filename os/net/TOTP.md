TOTP (HTOP, 2FA)
================

[TOTP][] ([RFC 6238]) is a time-based one-time password extension of
[HOTP], the HMAC-based OTP system.

### Secrets

TOTP uses a 160 bit secret, often encoded as a base-32 ASCII string. (The
formatting varies: sometimes the standard 20-characters with the standard
upper-case characters; sometimes eight space-separated groups of four
characters using lower-case instead.)

### otpauth URLs

There are also other parameters, which are often distributed along with
the secret in an `otpauth:` URL.

Format and Parameters (‡=required, †=recommended, otherwise optional):
- General format: `otpauth://TYPE/LABEL?PARAMETERS`
- Type: `htop` or `totp`
- Label: _issuer:account_ or just _account_
- ‡`secret`: in base-32 format
- `issuer`: If _issuer_ above not present; if both, must be identical.
- `digits`: `6` (default) or `8`
- `algorithm` optional `SHA1` (default), `SHA256`, `SHA512`
- `period`: `30` (deafult); seconds a code is valid for
- `counter`: required for HOTP; initial counter value

Samples:

    otpauth://totp/ACME%20Co:john.doe@email.com?secret=HXDMVJECJJWSRB3HWIZR4IFUGFTMXBOZ&issuer=ACME%20Co&algorithm=SHA1&digits=6&period=30
    otpauth://totp/Discord:joe@example.com?secret=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX&issuer=Discord

These URLS are usually distributed as a QR code which can be decoded with
`zbarimg`, Google Lens, etc.


Tools and Software
------------------

Secrets in base-32 format are technically 20 chars of upper-case and
numbers only with no spaces. Many systems give lower-case letters instead
and give the secret in five space-separated groups of 4 chars. If your
software doesn't accept this, these can be converted to standard format
with `tr ' ' -d | tr a-z A-Z`.

### oathtool

Unix command line tool to generate (from a TOTP secret) and validate (given
secret and OTP) TOTP one-time passwords. Provided by [oath-toolkit] and the
Debian `oathtool` package.

Generally, use `-` as the secret to read it from stdin. It accepts secrets
in upper and/or lower case, and ignores spaces, so you can cat pretty much
any format into `oathtool -b --totp -`. (Add `-v` to get the exact
parameters it used to generate the code.)



<!-------------------------------------------------------------------->
[oath-toolkit]: http://www.nongnu.org/oath-toolkit
[TOTP]: https://en.wikipedia.org/wiki/Time-based_one-time_password
[HOTP]: https://en.wikipedia.org/wiki/HMAC-based_one-time_password
[RFC 6238]: https://www.rfc-editor.org/info/rfc6238/
