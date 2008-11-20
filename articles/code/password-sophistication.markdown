# Password Sophistication

<cite>November 12th, 2007</cite>

I went looking for one of those JavaScript, password strength meter things like you see on some signup pages (see [Google Signup](https://www.google.com/accounts/NewAccount)) which attempt to coerce you into believing the security of the password you are about to enroll with. I wanted to use it for a new site I am working on and I do think there are merits to forcing users to make a decision between accepting a _Secure_ versus an _Insecure_ password.

While I am a developer and I know JavaScript, I didn't feel like implementing the _strength_ algorithm myself; so I went in search of an existing solution. In the course of the search for the right solution(s), I happened upon two learnings:

1. The code for implementation was not _purty_; to be addressed in Findings
1. I became hesitant to call the whole process a "strength" test

## Sophistication

Calling the algorithm a _security strength_ test really violated by sensibility. Passwords are broken all the time and considering that most of the client-side testing algorithms don't even use a dictionary lookup, I really believe that no assurance of strength can be given about a user's password when using the majority of these algorithms.

Instead, the test or score reflects the **Sophistication** of the user's password. Most of the algorithms look for the following patterns:

1. Password length; hopefully over 8
1. At least one lower-case letter
1. At least one upper-case letter
1. At least one digit
1. A special character like {!,#,$,%,...} 
1. Combinations of upper- and lower-case letters 
1. Combinations of letters and digits
1. Combinations of letters, digits, and special characters

For the occurrences of letters, digits, and special characters, scores go up as frequency increases; with a cap.

To this end, it is my belief that only the sophistication of the user's password, in relation to the known patterns of insecurity, is at question.

So, my proposal is to not use the classifications of _Insecure_, _Mediocre_, _Secure_, and _Very Secure_, but to instead use:

1. Risky
1. Weak
1. Smart
1. Sophisticated

Of course, it would be funnier to use something like:

1. So ... you really don't care about security?
1. Is that really your password?
1. Getting warmer
1. Sweet!

But, my wife does not like those so I won't be using them.

## Findings

A quick question to [the Google](http://www.google.com/search?q=javascript+password+strength+meter) produced the following two links at some point:

1. [Geek Wisdom](http://www.geekwisdom.com/dyn/passwdmeter): which I used for the Scoring algorithm
1. [Code & Coffee](http://www.codeandcoffee.com/2007/06/27/how-to-make-a-password-strength-meter-like-google/): which I used for the Interface Design

### Scoring

I chose the scoring algorithm from Geek Wisdom because it was actually very paranoid. None of the passwords I use or my friends use on regular basis, and which are fairly sophisticated, even made it into the _secure_ classification.

The code was actually kind of ugly; in that it seemed some cycles were getting wasted and the regular expressions needed improving. The author of the original code would agree to as much; and the comments on the post verify as much.

### Design

The design code from Code & Coffee was also useful and [simple enough](http://www.codeandcoffee.com/wp-content/uploads/pwd_strength.js). It came with a built in scoring algorithm, which was not paranoid enough.

I liked how simple the solution to the meter was, but I did not like that the colors were essentially hard-coded in. I also don't like that the _strength_ classifications (like Secure, Insecure, etc.) are hard-coded, but this is a less trivial solution to program and probably not worth the effort.

## Implementation

My initial implementation was essentially the implementation from Code & Coffee with the algorithm of Geek Wisdom; but what I really wanted was a nice OO thing. I also wanted to be able to define colors in CSS.

My final JavaScript looks like the following (passwd.js):
[code lang="javascript"]
PasswordSophistication = Class.create();
Object.extend(PasswordSophistication.prototype, {
  initialize: function(passwordFieldId, fieldIdPrefix) {
    this.passwordField = document.getElementById(passwordFieldId);
    this.barElement = document.getElementById(fieldIdPrefix + "_bar");
    this.textElement = document.getElementById(fieldIdPrefix + "_text");

    // rate = [minimum-to-meet, text-to-display, css-class]
    this.rates = [
      [90, "Sophisticated", "sophisticated"],
      [60, "Smart", "smart"],
      [30, "Weak", "weak"],
      [0, "Risky", "risky"]];
    this.defaultRate = [null, "Password Sophistication", "risky"];
  },

  passwd: function() {
    return this.passwordField.value;
  },

  // Score the password
  score: function () {
    var score = 0;
    passwd = this.passwd();
    // Length
    len = passwd.length;
    if (len > 7) {score += 18;}
    else if (len > 4) {score += 6;}
    else if (len > 0) {score += 3;}

    // Letters
    if (passwd.match(/[a-z]/)) {score += 1;}
    if (passwd.match(/[A-Z]/)) {score += 5;}

    // Numbers
    if (passwd.match(/[0-9]/)) {score += 5;}
    if (passwd.match(/([0-9].*){3}/)) {score += 5;}

    // 1 or 2 Special characters
    if (passwd.match(/[,!@#$%^&*?_~=+-]/)) {score += 5;}
    if (passwd.match(/([,!@#$%^&*?_~=+-].*){2}/)) {score += 5;}

    // Combinations
    if (passwd.match(/([a-z].*[A-Z])|([A-Z].*[a-z])/)) {score += 2;}
    if (passwd.match(/([0-9].*[a-zA-Z]|[a-zA-Z].*[0-9])/)) {score += 2;}
    rex = /([a-zA-Z0-9].*[!,@#$%^&*?_~=+-]|[!,@#$%^&*?_~=+-].*[a-zA-Z0-9])/
    if (passwd.match(rex)) {score += 2;}
  
    return score * 2; // Because score maxes at 50
  },

  // Update the view
  update: function () {
    if (!(this.barElement && this.textElement)) {return;}

    score = this.score();

    rate = null;
    for (i = 0; i < this.rates.length && rate == null; i++)
      if (score > this.rates[i][0]) {rate = this.rates[i];}
    if (rate == null) {rate = this.defaultRate;}
 
    this.barElement.style.width = score + "%";
    this.barElement.className = rate[2];
    this.textElement.innerHTML = rate[1];
  }
});
[/code]

Following is an excerpt of how to use it:
[code lang="html"]
<script src="/javascripts/passwd.js?1189743366" type="text/javascript"></script>
<link href="/stylesheets/passwd.css?1189743142"
  media="screen" rel="Stylesheet" type="text/css" />
<p>
  <div class='label'><label for='password'>Password</label></div>
  <div>
    <input id="user_password" name="user[password]"
      onkeyup="passwdMeter.update();"
      size="30" type="password" />
  </div>

  <div id='passwd_text'>Password Sophistication</div>
  <div id='passwd_meter'><div id='passwd_bar'>&nbsp;</div></div>
</p>
<script>
  passwdMeter = new PasswordSophistication('user_password', 'passwd');
</script>
[/code]

So, the important part is the initialization of the meter via the PasswordSophistication object. The PasswordSophistication constructor expects two DOM Id's:

1. First, is the Id pointing to the password field; 'user_password' in this case
1. Second, is the prefix of the DOM Id that represent the meter __bar__ and __text__

The use of the prefix for the fields is the same implementation as that originally defined in the Code & Coffee article.

The other important piece is the __onkeyup__ defined in the password field, which calls _update()_ on the password meter object.

Now, colors come in via CSS (passwd.css):
[code lang="css"]
#passwd_text {font-size: 70%; color: #777;}
#passwd_meter {height: .5ex; border: 1px solid #ddd;}
#passwd_bar {height: .5ex;}
#passwd_bar.sophisticated {background-color: green;}
#passwd_bar.smart {background-color: #a0ff01;}
#passwd_bar.weak {background-color: orange;}
#passwd_bar.risky {background-color: red;}
[/code]

That's pretty simple. Here's what it looks like with my __smart__ password:

<img src="/images/articles/code/smart-passwd.png">

## Future Improvements

There are lots of things that could improve the JavaScript. The most important are in the scoring algorithm, but the question is _"What value is gained by doing so?"_

Well, if someone has a good answer, here is my list:

1. Move the scoring rules into an ordered list of lambda functions that each accept the password and return an incremental score. If this was done, the score() method would be nothing more than an iterator that sums the scores of the lambda functions.
1. Make the rates array a set of Objects that methods can be called on; like minScore, cssClass, and title.
1. Provide a mechanism to allow the classification titles (ie Smart, Weak, etc.) and the CSS classes to be defined outside the PasswordSophistication prototype.
