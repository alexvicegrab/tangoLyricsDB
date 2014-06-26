require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  setup do
    @language = Language.new
    @language.name = " kLiNGon "
    @language.iso = " KL "
  end
  
  test "should not save language without a name" do
    @language.name = nil
    assert_not @language.save
  end
  test "should not save language without an ISO" do
    @language.iso = nil
    assert_not @language.save
  end
  test "should not save language with a short name" do
    @language.name = "Mw"
    @language.iso = "mw"
    assert_not @language.save
  end
  test "should not save language with existing name" do
    @language.name = "eNglIsh"
    assert_not @language.save
  end
  test "should not save language with existing ISO" do
    @language.iso = "EN"
    assert_not @language.save
  end
  test "should normalise language name & ISO" do
    @language.save!
    assert_equal @language.name, "Klingon"
    assert_equal @language.iso, "kl"
  end
end
