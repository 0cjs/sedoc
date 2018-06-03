TLS (SSL) Information
=====================

Below, SEIS is the [Information Security Stack Exchange][SEIS].

Testing
-------

* The [Symantic View Browser Warnings][sy-bw] page offers links
  to sites that should trigger various warnings in the client.
  Unfortunately not usable with Chrome >=66 because most certs
  are old enough to trigger `ERR_CERT_SYMANTEC_LEGACY`.
* [Digicert][digicert-check] offers a service that checks certs
  from servers.
* [Geekflare] offers a list of various TLS testing sites.


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
insight into this and also has lots of references. (Follow-up on
SEIS [Key Management in Interception Proxies?][se-51500]) Also see
[hboeck2015], "TLS Interception Considered Harmful Video and Slides."

Detecting and migigating MITM attacks:
* SEIS [answer on proxy-generated certs][se-49526]
* SEIS [Mitigation against MITM at Starbucks][se-84323]
* SEIS [How to know if your company does TLS intercept][se-129719]
* SEIS [How can end-users detect malicious attempts at SSL spoofing
  when the network already has an authorized SSL proxy?][se-16293]

[BCP 188] is a starting point for researching pervasive monitoring
mitigation.


Other Notes
-----------

* [Superfish](https://arstechnica.com/information-technology/2015/02/lenovo-pcs-ship-with-man-in-the-middle-adware-that-breaks-https-connections/)
* [Chromebook Enterprise SSL Inspection](https://support.google.com/chrome/a/answer/3504942)



[BCP 188]: https://tools.ietf.org/html/bcp188
[EV]: https://en.wikipedia.org/wiki/Extended_Validation_Certificate
[HSTS]: https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security
[HTTP Tunnel]: https://en.wikipedia.org/wiki/HTTP_tunnel
[Proxytunnel]: http://proxytunnel.sourceforge.net/intro.php
[SEIS]: https://security.stackexchange.com/
[corporate MITM]: https://directorblue.blogspot.com/2006/07/think-your-ssl-traffic-is-secure-if.html
[digicert-check]: https://www.digicert.com/help/
[geekflare]: https://geekflare.com/ssl-test-certificate/
[hboeck2015]: https://blog.hboeck.de/archives/875-TLS-interception-considered-harmful-video-and-slides.html
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
[sy-bw]: https://cryptoreport.websecurity.symantec.com/checker/views/sslCheck.jsp
