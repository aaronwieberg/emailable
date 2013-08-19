## Emailable ##

A simple DSL which is used to define one or more mailing lists for
Ruby classes.

## Usage ##

Defining a contact list begins with including the Emailable module
then the mailing lists defined within emailable.

```ruby
class Project
  include Emailable

  emailable do
    mailing_list do
      to :contact
      cc ->(project) { project.investigators }
      bcc "mailbox@example.org"
    end

    mailing_list :admins do
      to ->(project) { Administrator.all.collect(&:email) }
      cc [:contact, :investigators]
      bcc MAILBOX
    end
  end
  

  def contact
    "contact@example.org"
  end


  def investigators
    ["a@example.org", "b@example.org"]
  end
end
```

The example above uses `Emailable` to define two mailing lists.  The first example
creates the "default" mailing list, as no name was given.  The second example
creates a mailing list with the name "admins".  Using this example you can use
the public mailing_list method on instances of `Project`.

```ruby
project = Project.new
project.mailing_list # => { to: "contact@example.org", cc: ["a@example.org", "b@example.org"], bcc: "mailbox@example.org" }

Administrator.all.collect(&:email) # => ["a@example.org"]
MAILBOX # => "m@example.org"
project.mailing_list(:admins) # => { to: ["a@example.org"], cc: ["contact@example.org", "a@example.org", "b@example.org"], bcc: "m@example.org" }
```

### Combined With ActionMailer

A typical use case may be that you have a mailer that sends a notification
because some activity occured on a Project, for example, and you don't care
who the recipients are you just want to notify them.  You can simply merge
the mailing_list with additional parameters to mail, and the email addresses
defined by the contact list will receive the message.

```ruby
class ActivityMailer < ActionMailer::Base
  def activity_notification(record)
    mail(record.mailing_list.merge({ subject: "Activity Occured" }))
  end
end
```

## Warranty ##

This software is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantibility and fitness for a particular
purpose.

## License ##

Copyright (c) 2013 Aaron C. Wieberg

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
