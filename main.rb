require 'gmail'
require 'yaml'
require 'base64'
require './helper.rb'
require 'model/mail.rb'

full_set = []
identity = YAML.load_file(".identity")
Gmail.connect(Base64.decode64(identity['account']), Base64.decode64(identity['password'])) do |gmail|
  inbox = gmail.inbox.find(:all)
  inbox.each {|email|
    full_set << Mail.new(
      email.uid,
      email.from,
      email.subject,
      Helper.html2text(email.body.raw_source)
    )
  }
end


