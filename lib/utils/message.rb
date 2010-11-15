require 'net/imap'
require 'time'
require 'tmail'


module Gmailer
  
  class Message
    
    attr_reader :date,:to,:from,:subject,:body,:raw,:uid
    
    
    def initialize(header,raw,uid,mailer)
      @header ||= header
      @raw_rfc ||= raw
      @uid ||= uid
      @mailer ||= mailer
      @date ||= get_date
      @to   ||= get_to
      @from ||= get_from
      @subject ||= get_subject
      @body ||= get_body
      @raw ||= get_raw
    end
    
    
    def move(new_label)
      @mailer.move(@uid,new_label)
    end
    
    private
    
    def get_date
      header? ? (return Time.parse(@header.first.attr["ENVELOPE"].date)) : (return "")
    end
    
    def get_to
      header? ? (return (@header.first.attr["ENVELOPE"].to.first.mailbox + '@' + @header.first.attr["ENVELOPE"].to.first.host).downcase) : (return "")
    end
    
    def get_from
      header? ? (return (@header.first.attr["ENVELOPE"].from.first.mailbox + '@' + @header.first.attr["ENVELOPE"].to.first.host).downcase) : (return "")
    end
    
    def get_subject
      header? ? (return @header.first.attr["ENVELOPE"].subject) : (return "")
    end
    
    def get_body
      raw? ? (return TMail::Mail.parse(@raw_rfc.first.attr["RFC822"])) : (return "")
    end
    
    def get_raw
      raw? ? (return @raw_rfc.first.attr["RFC822"]) : (return "")
    end
    
    def header?
      (@header.nil? || @header.first.attr["ENVELOPE"].to.nil? || @header.first.attr["ENVELOPE"].from.nil?) ? false : true
    end
    
    def raw?
      (@raw.nil? || @raw.first.nil?) ? false : true
    end
    
  end
end