require 'net/imap'

module Gmailer

class Helper
  
  attr_reader :success, :current_order
  
  
    def initialize(username,password)
      raise(ArgumentError, "please enter both the username and password") if username.nil? or password.nil?
      
      @username ||= username
      @password ||= password
      @imap ||= Net::IMAP.new('imap.gmail.com','993',true)
      @success = login
      @current_order = 'ascending'
      @list = 1 
      @message = nil           
    end
    
    def label(label)
      folder = @imap.select(label)
      @list = uids
      return folder.data.text.strip!
    end
    
    def list_labels
        (@imap.list("", "%") + @imap.list("[Gmail]/", "%")).inject([]) { |labels,label|
          label[:name].each_line { |l| labels << l }; labels }
    end
    
    
    def get_next_message
      @message ? (return @message) : (return message)
    end
    
    # toggles the order from descending to ascending or vice versa.
    def toggle_order(order)
       (@current_order = order;@list = 1;@message = nil;return true) if order.match('ascending')
       (@current_order = order;@list = uids;@message = nil;return true) if order.match('descending')
    end
    
    def move(uid,new_label)
      @imap.store(uid, "+FLAGS", [:Deleted])
      response = @imap.copy(uid, "#{new_label}")
      (@message = nil) if response[2].text.match(/Success/)  
      return response[2].text
    end
    
      
    private
    
    
    def login
      login = @imap.login(@username,@password)
      @imap.select('inbox')
      true if login.name == 'OK'
    end
    
    def uids
      return @imap.responses["EXISTS"][-1]
    end
    
    def message
        header = @imap.fetch(@list,'ENVELOPE')
        raw = @imap.fetch(@list,'RFC822')
        message = Message.new(header,raw, @list, self)
        puts "fetched mail from #{message.from} uid:#{@list}"
        (@current_order.match('ascending')) ? (@list = @list + 1) : (@list = @list - 1)
        @message = message
      return message
      
    end
    
    
end

end