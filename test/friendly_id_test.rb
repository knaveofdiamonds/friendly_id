require 'rubygems'
require 'test/unit'
require 'activerecord'
require "#{File.dirname(__FILE__)}/../lib/knave/friendly_id"
require 'mocha'

ActiveRecord::Base.send :include, Knave::FriendlyId

class Tag < ActiveRecord::Base
  friendly_id :name
end

class FriendlyIdTest < Test::Unit::TestCase

  def test_numeric_ids_still_work
    Tag.expects(:find_without_friendly_id).with(1).returns(stub)
    assert Tag.find(1)
  end

  def test_name_passed_through_as_id
    Tag.expects(:find_without_friendly_id).with(:first, {}).returns(stub)
    assert Tag.find("roland+swingler")
  end

  def test_unfound_name_raises_record_not_found
    Tag.expects(:find_without_friendly_id).with(:first, {}).returns(nil)
    assert_raise(ActiveRecord::RecordNotFound) { Tag.find("nonexistent") }
  end

  def test_options_passed_through
    Tag.expects(:find_without_friendly_id).with(:first, {:include => :something}).returns(stub)
    assert Tag.find("roland", :include => :something)
  end

  # TODO need to test that the with_scope and to_param actually work
end
