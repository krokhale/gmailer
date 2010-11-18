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
      @list = uids.reverse
      @list_asc = @list.dup
      @list_desc = @list.dup.reverse
            
    end
    
    def label(label)
      folder = @imap.select(label)
      @list = uids.reverse
      @list_asc = @list.dup
      @list_desc = @list.dup.reverse
      return folder.data.text.strip!
    end
    
    def list_labels
        (@imap.list("", "%") + @imap.list("[Gmail]/", "%")).inject([]) { |labels,label|
          label[:name].each_line { |l| labels << l }; labels }
    end
    
    def get_next_message
      (@current_order.match('ascending')) ? (uid = @list_asc.pop; return message(uid)) : (uid = @list_desc.pop; return message(uid))
      
    end
    
    # toggles the order from descending to ascending or vice versa.
    def toggle_order(order)
      order.match(@current_order) ? (return @current_order) : (@current_order = order;@list_asc = @list.dup;@list_desc = @list.dup.reverse)
    end
    
    def move(uid,new_label)
      @imap.store(uid, "+FLAGS", [:Deleted])
      response = @imap.copy(uid, "#{new_label}")
      return response[2].text
    end
    
      
    private
    
    
    def login
      login = @imap.login(@username,@password)
      @imap.select('inbox')
      true if login.name == 'OK'
    end
    
    def uids
      return @imap.search(["ALL"])
    end
    
    def message(uid)
        header = @imap.fetch(uid,'ENVELOPE')
        raw = @imap.fetch(uid,'RFC822')
        message = Message.new(header,raw, uid, self)
        puts "fetched mail from #{message.from}"
      return message
      
    end
    
    
end

end