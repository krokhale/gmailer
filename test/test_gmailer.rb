#!/usr/bin/ruby
require 'helper'

class TestGmailer < Test::Unit::TestCase 
  def test_new 
    gmailer = Gmailer::Gmail.new( 'jon.hogue@gmail.com', 'C@rrR0b3' )
    assert_kind_of gmailer, 'Gmailer'
  end
  
  def test_default_settingsg
    gmailer = Gmailer::Gmail.new( 'jon.hogue@gmail.com', 'C@rrR0b3' )
    assert( gmailer.success )
    assert( gmailer.current_folder eq "inbox" )
  end
   
end
