$:.unshift(File.dirname(__FILE__))

require 'pathname'
require 'date'
require 'utils/tasks'
require 'utils/message'

# Wrapper module for conforming namespace for all the classes in this gem.
module Gmailer

#The Base class that defines the skeleton of the functions to be performed by the gem.
class Gmail
  
  attr_reader :username, :password, :success, :current_folder, :messages, :list_labels
  attr_accessor :mailer, :current_order
  
  
  def initialize(username,password)
    @mailer ||= Gmailer::Helper.new(username,password)
    @success ||= @mailer.success
    @current_folder = 'inbox'
    @current_order = @mailer.current_order
    @messages = @mailer.list
    @list_labels = @mailer.list_labels
  end
  
class << self

# login method initializes a helper class, which does most of the heavy lifting.  
  def login(username, password)
    return Gmailer::Gmail.new(username,password)
  end
  
end

# changes the label, as in changes the current folder in the mailbox.  
  def label(label)
    response = @mailer.label(label)
    @current_folder = response.split[0]
    return response
  end

# lists all the labels, or folders in the mailbox.  
  def labels
    return @mailer.list_labels
  end

# sets the order as described in the spec, the default is ascending.  
  def order_by_date(order)
    return @mailer.toggle_order(order)
  end

# gets next message as described in the spec.  
  def get_next_message
    return @mailer.get_next_message
  end
  
    
end
end