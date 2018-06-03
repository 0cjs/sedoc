TLS (SSL) Information
=====================

Below, SEIS is the [Information Security Stack Exchange][SEIS].

Certificates
------------

* [Extended Validation Certficates][EV] assert the legal identity
  of a certificate owner.
* [HTTP Strict Transport Security][HSTS] pins public keys.
  * User-installed root CAs in Chrome are [exempted from certficate
    public key pinning requirements][imperialviolet.org/pinning].

Connectivity
------------

Wikipedia [HTTP Tunnel] page discusses `CONNECT` used for TLS
tunneled through proxies and alternate tunnel methods. [Proxytunnel]
uses connect for tunnelling arbitrary apps via both TCP and TLS
(via OpenSSL) tunnelling through `CONNECT`.

[Corporate MITM] (politely, "SSL Interception") is a common thing.
See [se-33976], [se-87415], etc. Also national: [se-172024]. The
paper [SSL/TLS Interception Proxies and Transitive Trust][jarmoc] by
Jeff Jarmoc (Dell SecureWorks Counter Threat Unit) may provide some
insight into this and also has lots of references. Follow-up on
SEIS [Key Management in Interception Proxies?][se-51500]

Detecting and migigating MITM attacks:
* SEIS [answer on proxy-generated certs][se-49526]
* SEIS [Mitigation against MITM at Starbucks][se-84323]
* SEIS [How to know if your company does TLS intercept][se-129719]
* SEIS [How can end-users detect malicious attempts at SSL spoofing
  when the network already has an authorized SSL proxy?][se-16293]

[BCP 188] is a starting point for researching pervasive monitoring
mitigation.



[BCP 188]: https://tools.ietf.org/html/bcp188
[EV]: https://en.wikipedia.org/wiki/Extended_Validation_Certificate
[HSTS]: https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security
[HTTP Tunnel]: https://en.wikipedia.org/wiki/HTTP_tunnel
[Proxytunnel]: http://proxytunnel.sourceforge.net/intro.php
[SEIS]: https://security.stackexchange.com/
[corporate MITM]: https://directorblue.blogspot.com/2006/07/think-your-ssl-traffic-is-secure-if.html
[imperialviolet.org/pinning]: https://www.imperialviolet.org/2011/05/04/pinning.html
[jarmoc]: https://media.blackhat.com/bh-eu-12/Jarmoc/bh-eu-12-Jarmoc-SSL_TLS_Interception-WP.pdf
[se-16293]: https://security.stackexchange.com/q/16293/12254
[se-33976]: https://security.stackexchange.com/q/33976/12254
[se-49526]: https://security.stackexchange.com/a/49526/12254
[se-51500]: https://security.stackexchange.com/q/51500/12254
[se-84323]: https://security.stackexchange.com/a/84323/12254
[se-87415]: https://security.stackexchange.com/questions/87415/certificate-pinning-and-corporate-mitm
[se-129719]: https://security.stackexchange.com/a/129719/12254
[se-172024]: https://security.stackexchange.com/a/172024/12254
