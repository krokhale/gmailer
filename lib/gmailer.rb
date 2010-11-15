$:.unshift(File.dirname(__FILE__))

require 'pathname'
require 'date'
require 'utils/tasks'
require 'utils/message'


module Gmailer

class Gmail
  
  attr_reader :username, :password, :success, :current_folder, :messages
  attr_accessor :mailer, :current_order
  
  
  def initialize(username,password)
    @mailer ||= Gmailer::Helper.new(username,password)
    @success ||= @mailer.success
    @current_folder = 'inbox'
    @current_order = 'ascending'
    @messages = @mailer.list
    @counter = @messages.count
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
    @current_order = order
  end
  
  def get_next_message
    return Gmailer::Helper.get_next_message
  end
  
  def raw
    return Gmailer::Helper.raw
  end
  
  def move
    return Gmailer::Helper.move
  end
    
end
end