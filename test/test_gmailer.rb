require "../lib/gmailer"
require "test/unit"

class TestGmailer < Test::Unit::TestCase 
  
  @gmailer = Gmailer::Gmail.new( 'jon.hogue@gmail.com', 'C@rrR0b3' )
  
  def test_new 
    assert_kind_of(@gmailer, 'Gmailer')
  end
  
  def test_default_settings
    assert(@gmailer.success)
    assert(@gmailer.current_folder eq "inbox")
  end
  
  def test_change_label
    response  = true
  end
    
   
end