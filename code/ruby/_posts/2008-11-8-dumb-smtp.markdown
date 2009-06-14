---
layout: post
title: Dumb SMTP
summary: The Reaffirming SMTP Server
---

I saw this post about a [Mock SMTP](http://d.hatena.ne.jp/koseki2/20081030/mocksmtpd) server off of [RubyFlow](http://rubyflow.com) today and it scared the living crap out of me. You bet it did! Is that what a mock of something is considered to be?

In response, I'm attaching the code for a dumb SMTP server that I wrote in less than two hours that I have used in my Rails applications to test what and to whom was getting mailed. All this little server does is respond with kind words; as in, it says `OK` to everything it can. It's an eager server that will reaffirm everything you may have thought about SMTP.

It also wouldn't be to hard to ask it to store the emails for grabbing later. It would certainly be a lot less code and a lot friggin' easier to read.

{% highlight ruby %}
#!/usr/bin/env ruby

# I am a stupid SMTP server. Though I speak SMTP, all I do is regurgitate what
# the sender sends me. Use me for doing manual testing of SMTP clients that have
# simple needs.
#
# Example usage:
#   dumb-smtp.rb localhost 25252
#
# Then, have your client try and send email to localhost:25252 and watch the
# STDOUT of dumb-smtp. Theoretically, your client will think it actually sent
# the email and you can observe what your client actually sent.
#
# Feel free to keep me simple by leaving me alone; unless you have some cool 
# ideas.
#
# I have been known to work extremely well with ActionMailer :)
#
require 'socket'

class SmtpResponder
  def initialize
    @data = false
    @closed = false
    @domain = ''
  end

  def handle(line)
    line = line.strip
    return more_data(line) if @data

    command, data = *line.split(' ', 2)
    command = command.downcase.gsub(/ +/, '_').to_sym
    self.send(command, data)
  end

  def ehlo(domain) @domain = domain; "250 OK #{domain}"; end

  def ok(info) "250 OK #{info}"; end
  alias :mail :ok
  alias :rcpt :ok

  def data(info)
    @data = true
    "354 Start mail input; end with <CRLF>.<CRLF>"
  end

  def more_data(data)
    return nil unless data == "."
    @data = false
    "250 OK data received"
  end

  def quit(data)
    @closed = true
    "221 #{@domain} Service closing transmission channel"
  end

  def closed?; @closed; end

  def method_missing(methodname, *args)
    "500 Syntax error, command unrecognized"
  end
end

server = TCPServer.open(ARGV[0], ARGV[1])
while (socket = server.accept)
  socket.puts("220 dumb-smtp.foo Service ready")
  responder = SmtpResponder.new
  socket.each do |line|
    $stdout.puts("-- #{line.strip}")
    response = responder.handle(line)
    if response
      $stdout.puts("<< #{response}")
      socket.puts(response)
    end
    break if responder.closed?
  end
  socket.close
end
server.close
{% endhighlight %}

If you do as the comments say, you're golden. You can even tell your appropriate Rails configuration file to talk to the port you reference and it will work. You could do that like so in your `development.rb`:

{% highlight ruby %}
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => 'localhost', :port => 25252, :domain => 'foo.bar'
}
{% endhighlight %}

Now, I should note that I wrote this while [working for Centro](http://centro.net) ... my ex-employer, silly.
