require 'net/imap'

module Gmailer

class Helper
  
  attr_reader :success, :list
  
  
    def initialize(username,password)
      raise(ArgumentError, "please enter both the username and password") if username.nil? or password.nil?
      
      @username ||= username
      @password ||= password
      @imap ||= Net::IMAP.new('imap.gmail.com','993',true)
      @success = login
      @list = messages.collect.sort_by(&:date)
            
    end
    
    def label(label)
      folder = @imap.select(label)
      return folder.data.text.strip!
    end
    
    def list_labels
        (@imap.list("", "%") + @imap.list("[Gmail]/", "%")).inject([]) { |labels,label|
          label[:name].each_line { |l| labels << l }; labels }
    end
    
      
    private
    
    
    def login
      login = @imap.login(@username,@password)
      @imap.select('inbox')
      true if login.name == 'OK'
    end
    
    def messages
      mails = []
      @imap.search(["SUBJECT", "hello", "NOT", "NEW"]).each do |uid|
        header = @imap.fetch(uid,'ENVELOPE')
        raw = @imap.fetch(uid,'RFC822')
        message = Message.new(header,raw)
        mails << message
        puts "fetched mail from #{message.from}"
      end
      return mails
      
    end
    
    
end

end