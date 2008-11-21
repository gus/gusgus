# Canonical: Rails ActionMailer extension for substituting inline email addresses

<cite>November 8th, 2008</cite>

[excerpt]
I and a co-worker (Eric Schwartz) wrote [Canonical](http://github.com/centro/canonical/tree/master) for [Centro](http://centro.net) -  my current employer. Canonical does for your Rails app what Postfix's [canonical](http://www.postfix.org/canonical.5.html) would do for your sys-admin. But now, you have the control! Ha ha!

Check out the README for everything you need to know.
[/excerpt]

---

Alright fine, Canonical is an ActionMailer extension that acts just like the Postfix utility of the same name. Essentially, Canonical lets you substitute the To, CC, and/or BCC email destinations with one of many replacements via a rule. It can be great for your integration and testing environments to direct all mail so that it is sent to a QA email address or something.

You may add a canonical rule like the following to send any email from the system to any address to the QA email distribution list:

    TMail::Mail.add_canonical_override(/.*/, 'qa@foo.bar')

Assuming you are working at Foo Bar, that rule will match any destination address that has any character in it - meaning, it matches everything - and will substitute the matched email with qa@foo.bar. This is the same as saying the following in Postfix’s canonical file:

    /.*/, qa@foo.bar

What you should notice is that canonical expects to see a regular expression as the first argument. Passing in anything that does not respond to =~ will result in an error.

Have fun!