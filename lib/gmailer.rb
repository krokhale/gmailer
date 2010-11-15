$:.unshift(File.dirname(__FILE__))

require 'pathname'
require 'date'
require 'utils/tasks'
require 'utils/message'


module Gmailer

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
  
  def login(username, password)
    return Gmailer::Gmail.new(username,password)
  end
  
end
  
  def label(label)
    response = @mailer.label(label)
    @current_folder = response.split[0]
    return response
  end
  
  def labels
    return @mailer.list_labels
  end
  
  def order_by_date(order)
    return @mailer.toggle_order(order)
  end
  
  def get_next_message
    return @mailer.get_next_message
  end
  
    
end
end