SMS
===

Why SMS is Bad for Two-step (2FA, MFA) Authentication 
-----------------------------------------------------

In 2016-06 NIST published a [public preview draft][800-63Bgit] of
[NIST Special Publication 800-63B][800-63B], "Digital Identity
Guidelines Authentication and Lifecycle Management." In that edition,
§5.1.3.2 Out-of-Band Verifiers stated:

> Due to the risk that SMS messages or voice calls may be intercepted
> or redirected, implementers of new systems should carefully consider
> alternative authenticators....
> Out-of-band authentication using [SMS or voice] is deprecated, and
> is being considered for removal in future editions of this guideline.

Since then the [800-63B] has been released and now includes in an
update dated 2017-06-05 ([beb5df7]) §5.1.3.3 Authentication using the
Public Switched Telephone Network:

> Use of the PSTN for out-of-band verification is RESTRICTED as
> described in this section and in Section 5.2.10. If out-of-band
> verification is to be made using the PSTN, the verifier SHALL verify
> that the pre-registered telephone number being used is associated
> with a specific physical device. Changing the pre-registered
> telephone number is considered to be the binding of a new
> authenticator and SHALL only occur as described in Section 6.1.2.

> Verifiers SHOULD consider risk indicators such as device swap, SIM
> change, number porting, or other abnormal behavior before using the
> PSTN to deliver an out-of-band authentication secret.

### Articles

* Wired, [So Hey You Should Stop Using Texts for Two-Factor
  Authentication][wired] (2016-06)
* Slate, [It's Official: Using Text Messages to Secure Your Passwords
  Is a Bad Idea][slate] (2016-06)
* Krebs on Security, [The Limits of SMS for 2-Factor
  Authentication][krebs] (2016-09)
* The Register, [Standards body warned SMS 2FA is insecure and nobody
  listened][register] (2016-12)
* How-To Geek, [Why You Shouldn't Use SMS for Two-Factor
  Authentication (and What to Use instead)][htg] (2017-06)
* Mobility Arena, [Google plans to phase out two-step verification via
  SMS][mobilityarena] (2018-06)
* Forbes, [All That's Needed To Hack Gmail And Rob Bitcoin: A Name And
  A Phone Number][forbes] (2017-09)
* Naked Security (Sophos), [Why SMS two-factor authentication puts
  your bitcoins at risk][sophos] (2017-09)
* TidBITS, [Facebook Shows Why SMS Isn't Ideal for Two-Factor
  Authentication][tidbits] (2018-02)  Includes many links to other
  references

[800-63B]: https://pages.nist.gov/800-63-3/sp800-63b.html 
[800-63Bgit]: https://github.com/usnistgov/800-63-3
[beb5df7]: https://github.com/usnistgov/800-63-3/commit/beb5df714b8ac5dd95dcc07c3e7f66ad20401bd3
[forbes]: https://www.forbes.com/sites/thomasbrewster/2017/09/18/ss7-google-coinbase-bitcoin-hack/
[htg]: https://www.howtogeek.com/310418/why-you-shouldnt-use-sms-for-two-factor-authenticaton/
[krebs]: https://krebsonsecurity.com/2016/09/the-limits-of-sms-for-2-factor-authentication
[register]: https://www.theregister.co.uk/2016/12/06/2fa_missed_warning/
[slate]: https://www.slate.com/blogs/future_tense/2016/07/26/nist_proposes_moving_away_from_sms_based_two_factor_authentication.html
[sophos]: https://nakedsecurity.sophos.com/2017/09/20/why-sms-two-factor-authentication-puts-your-bitcoins-at-risk
[tidbits]: https://tidbits.com/2018/02/19/facebook-shows-why-sms-isnt-Ideal-for-two-factor-authentication
[wired]: https://www.wired.com/2016/06/hey-stop-using-texts-two-factor-authentication
[mobilityarena]: https://mobilityarena.com/google-plans-phase-two-step-verification-via-sms/
