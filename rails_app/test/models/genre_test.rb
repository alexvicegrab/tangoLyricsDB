require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  setup do
    @genre = Genre.new
  end
  
  test "should not save genre without a name" do
    assert_not @genre.save
  end
  test "should not save genre with a short name" do
    @genre.name = "mew"
    assert_not @genre.save
  end
  test "should not save genre with existing name" do
    @genre.name = "tAnGo"
    assert_not @genre.save
  end
  test "should normalise genre name" do
    @genre.name = " tAnGOn "
    @genre.save!
    assert_equal @genre.name, "Tangon"
  end
end
