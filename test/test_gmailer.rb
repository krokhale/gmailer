require 'rubygems'
require "../lib/gmailer"
require "test/unit"

USR = ''
PWD = ''
LABEL = ''

class TestGmailer < Test::Unit::TestCase 
  
  
  def test_new 
    @gmailer = Gmailer::Gmail.login(USR, PWD)
    assert(@gmailer.class == Gmailer::Gmail)
  end
  
  def test_default_settings
    @gmailer = Gmailer::Gmail.login(USR, PWD)
    assert(@gmailer.success)
    assert(@gmailer.current_folder.match("inbox"))
  end
  
  def test_change_label
    @gmailer = Gmailer::Gmail.login(USR, PWD)
    assert(@gmailer.current_folder.match("inbox"))
    response = @gmailer.label(LABEL)
    assert(response.match(/Success/))
    assert(@gmailer.current_folder.match(LABEL))
  end
  
  def test_order_by_date
    @gmailer = Gmailer::Gmail.login(USR, PWD)
    assert(@gmailer.current_order.match("ascending"))
    @gmailer.order_by_date("descending")
    assert(@gmailer.current_order.match("ascending"))
  end
  
  def test_get_next_message
    @gmailer = Gmailer::Gmail.login(USR, PWD)
    assert(@gmailer.current_order.match("ascending"))
    message1 = @gmailer.get_next_message
    message2 = @gmailer.get_next_message
    assert(message1.date < message2.date)
    @gmailer.order_by_date("descending")
    message3 = @gmailer.get_next_message
    message4 = @gmailer.get_next_message
    assert(message3.date > message4.date)   
  end
    
    
    
end

