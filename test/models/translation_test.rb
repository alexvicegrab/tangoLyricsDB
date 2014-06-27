require 'test_helper'

class TranslationTest < ActiveSupport::TestCase
  setup do
    @translation = Translation.new
    @translation.song_id = songs(:one).id
    @translation.link = " http://someblog.com/donde-estas-corazon.html "
    @translation.language_id = languages(:one).id
  end
  
  test "should not save a translation without a link" do 
    @translation.link = nil
    assert_not @translation.save
  end
  test "should not save a translation without a language_id" do
    @translation.language_id = nil
    assert_not @translation.save
  end
  
  test "should not save a translation with short link" do
    @translation.link = " http://tiny.uk "
    assert_not @translation.save
  end
  test "should not save a translation with invalid link" do
    @translation.link = " someblog.com/donde-estas-corazon.html "
    assert_not @translation.save
  end
  test "should not save a translation with language_id less than 1" do
    @translation.language_id = 0
    assert_not @translation.save
  end
  test "should not save a translation with non-integer language_id" do
    @translation.language_id = 2.1
    assert_not @translation.save
  end

  test "should not save translation with existing link, language_id & song_id" do
    @translation.link = " http://www.gOogle.com/Rojo "
    @translation.language_id = languages(:two).id
    assert_not @translation.save
  end
  test "should save translation with existing link & language_id, but different song_id" do
    @translation.link = " http://www.gOogle.com/Rojo "
    @translation.song_id = songs(:two).id
    @translation.language_id = languages(:two).id
    assert @translation.save
  end
  test "should normalise translation link" do
    @translation.link = " http://someblog.com/donde-est%C3%A1s-coraz%C3%B3n.html "
    @translation.save!
    assert_equal @translation.link, "http://someblog.com/donde-est%C3%A1s-coraz%C3%B3n.html"
  end
  test "should convert translation accents" do
    @translation.link = " http://someblog.com/donde-estás-corazón.html "
    @translation.save!
    assert_equal @translation.link, "http://someblog.com/donde-est%C3%A1s-coraz%C3%B3n.html"
  end
  test "should not change link capitalisation" do
    @translation.link = " http://someblog.com/donde-estAs-corazOn.html "
    @translation.save!
    assert_equal @translation.link, "http://someblog.com/donde-estAs-corazOn.html"
  end
  test "should define translator if known" do
    @translation.link = " http://www.google.com/red.html"
    @translation.save!
    assert_equal @translation.translator_id, translators(:one).id, "#{@translation.translator_id}"
  end
end
