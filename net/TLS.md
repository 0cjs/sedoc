TLS (SSL) Information
=====================

Below, SEIS is the [Information Security Stack Exchange][SEIS].

Viewing Certificates
--------------------

To connect to a server and view the certificate chain it returns:

    openssl s_client </dev/null -showcerts \
        -servername www.example.com -connect www.example.com:443

The optional `-servername` argument determines the server name sent
via [SNI] for hosts that return different certs based on that.

Stdout includes both basic cert information and the encoded certs
themselves (in [PEM] format: `-----BEGIN CERTIFICATE-----` etc.); stderr
will print information about validation done by the client. Piping
stdout through:

    openssl x509 -noout -text

will return a detailed deconstruction of about the _first_ cert
returned, which is generally (always?) the client's certificate. To
see certs further up the chain (the second and subsequent certs) you
can save stdout to a file and extract the certs by hand.

There are lots of variations on this at [so-7885785].

I should write another program that automates the above stuff. (The
one I previously wrote is lost to the archives of some previous
employer.)


Testing
-------

* [badssl.com] seems the best for client testing.
* [SSL Labs Client Test]
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


TLS Interception / SSL Inspection
---------------------------------

[Corporate MITM][] (to use the less polite term) is a common thing.
See [se-33976], [se-87415], etc. Also national: [se-172024]. And
problematic, in part because most products that do this are broken.

* [durumeric2017] "The Security Impact of HTTPS Interception."
  First comprehensive study. Summary/analysis at [HTTPS Interception
  Harming Security][sslstore-harming]. Also [nemertes].
* [CERT TA17-075A] Technical Alert "HTTPS Interception Weakens TLS
  Security." Covers only TLS vulnerabilities introduced by the
  inspection itself, and not any other environmentally introduced
  vulnerabilities (e.g., logging).
* [CERT2015] "The Risks of SSL Inspection."
  > The fact that "SSL inspection" is a phrase that exists, should
  > be a blazing red flag that what you think SSL is doing for you
  > is fundamentally broken. Compounding the problem are the mistakes
  > that SSL inspection software authors are making.
* [EFF2015] "Dear Software Vendors: Please Stop Trying to Intercept
  Your Customers’ Encrypted Traffic." Technical analysis.
  > Certificate validation is a very complicated and tricky process
  > which has taken decades of careful engineering work by browser
  > developers. Taking certificate validation outside of the browser
  > and attempting to design any piece of cryptographic software
  > from scratch without painstaking security audits is a recipe
  > for disaster.
* [hboeck2015] "TLS Interception Considered Harmful." Video and Slides.
* GitHub.com/hanob/[superfishy]: Archive of software, links and other
  data involved in the Superfish / Komodia incident.
* [jarmoc2012] "SSL/TLS Interception Proxies and Transitive Trust".
  Broken products. Lots of references.
* SEIS [Key Management in Interception Proxies?][se-51500]

Search for "TLS Interception" and "SSL Inspection" for more.
Check suspect systems at [badssl.com].

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
[CERT TA17-075A]: https://www.us-cert.gov/ncas/alerts/TA17-075A
[CERT2015]: https://insights.sei.cmu.edu/cert/2015/03/the-risks-of-ssl-inspection.html
[EFF2015]: https://www.eff.org/deeplinks/2015/02/dear-software-vendors-please-stop-trying-intercept-your-customers-encrypted
[EV]: https://en.wikipedia.org/wiki/Extended_Validation_Certificate
[HSTS]: https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security
[HTTP Tunnel]: https://en.wikipedia.org/wiki/HTTP_tunnel
[PEM]: https://en.wikipedia.org/wiki/Privacy-enhanced_Electronic_Mail
[Proxytunnel]: http://proxytunnel.sourceforge.net/intro.php
[SEIS]: https://security.stackexchange.com/
[SNI]: https://en.wikipedia.org/wiki/Server_Name_Indication
[SSL Labs Client Test]: https://www.ssllabs.com/ssltest/viewMyClient.html
[badssl.com]: https://badssl.com.
[corporate MITM]: https://directorblue.blogspot.com/2006/07/think-your-ssl-traffic-is-secure-if.html
[digicert-check]: https://www.digicert.com/help/
[durumeric2017]: https://jhalderm.com/pub/papers/interception-ndss17.pdf
[geekflare]: https://geekflare.com/ssl-test-certificate/
[hboeck2015]: https://blog.hboeck.de/archives/875-TLS-interception-considered-harmful-video-and-slides.html
[imperialviolet.org/pinning]: https://www.imperialviolet.org/2011/05/04/pinning.html
[jarmoc2012]: https://media.blackhat.com/bh-eu-12/Jarmoc/bh-eu-12-Jarmoc-SSL_TLS_Interception-WP.pdf
[nemertes]: https://nemertes.com/tls-interception-good-bad-just-plain-ugly/
[se-129719]: https://security.stackexchange.com/a/129719/12254
[se-16293]: https://security.stackexchange.com/q/16293/12254
[se-172024]: https://security.stackexchange.com/a/172024/12254
[se-33976]: https://security.stackexchange.com/q/33976/12254
[se-49526]: https://security.stackexchange.com/a/49526/12254
[se-51500]: https://security.stackexchange.com/q/51500/12254
[se-84323]: https://security.stackexchange.com/a/84323/12254
[se-87415]: https://security.stackexchange.com/questions/87415/certificate-pinning-and-corporate-mitm
[so-7885785]: https://stackoverflow.com/q/7885785/107294
[sslstore-harming]: https://www.thesslstore.com/blog/https-interception-harming-security/
[superfishy]: https://github.com/hannob/superfishy
[sy-bw]: https://cryptoreport.websecurity.symantec.com/checker/views/sslCheck.jsp
