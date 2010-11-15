require 'net/imap'

module Gmailer

class Helper
  
  attr_reader :success, :list, :current_order
  
  
    def initialize(username,password)
      raise(ArgumentError, "please enter both the username and password") if username.nil? or password.nil?
      
      @username ||= username
      @password ||= password
      @imap ||= Net::IMAP.new('imap.gmail.com','993',true)
      @success = login
      @list = messages.collect.sort_by(&:date).reverse
      @current_order = 'ascending'
      @list_asc = @list.dup
      @list_desc = @list.dup.reverse
            
    end
    
    def label(label)
      folder = @imap.select(label)
      return folder.data.text.strip!
    end
    
    def list_labels
        (@imap.list("", "%") + @imap.list("[Gmail]/", "%")).inject([]) { |labels,label|
          label[:name].each_line { |l| labels << l }; labels }
    end
    
    def get_next_message
      (@current_order.match('ascending')) ? (return @list_asc.pop) : (return @list_desc.pop)
      
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
    
    def messages
      mails = []
      @imap.search(["ALL"]).each do |uid|
        header = @imap.fetch(uid,'ENVELOPE')
        raw = @imap.fetch(uid,'RFC822')
        message = Message.new(header,raw, uid, self)
        mails << message
        puts "fetched mail from #{message.from}"
      end
      return mails
      
    end
    
    
end

end