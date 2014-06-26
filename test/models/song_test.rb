require 'test_helper'

class SongTest < ActiveSupport::TestCase
  setup do
    @song = Song.new
    @song.title = " vIeNTo nOrTe "
    @song.genre_id = genres(:one).id
    @song.composer = " juAn d'aRienzo "
    @song.lyricist = " rOberto D'El dIA "
    @song.year = 1932
  end
  
  test "should not save song without a title" do
    @song.title = nil
    assert_not @song.save
  end
  test "should not save song without a genre" do
    @song.genre_id = nil
    assert_not @song.save
  end
  test "should not save song without a composer" do
    @song.composer = nil
    assert_not @song.save
  end
  test "should not save song without a lyricist" do
    @song.lyricist = nil
    assert_not @song.save
  end
  test "should save song without a year" do
    @song.year = nil
    assert @song.save
  end
  
  test "should not save song with a short title" do
    @song.title = "A"
    assert_not @song.save
  end
  test "should not save song with genre_id below 1" do
    @song.genre_id = 0
    assert_not @song.save
  end
  test "should not save non-integer genre_id" do
    @song.genre_id = 2.1
    assert_not @song.save
  end
  test "should not save song with a short composer" do
    @song.composer = "mew"
    assert_not @song.save
  end
  test "should not save song with a short lyricist" do
    @song.lyricist = "mew"
    assert_not @song.save
  end
  test "should not save song with a small year" do
    @song.year = 1701
    assert_not @song.save
  end
  test "should not save song with a large year" do
    @song.year = 2015
    assert_not @song.save
  end
  
  test "should not save song with existing name" do
    @song.title = " dE vUeltA al Bulincillo "
    assert_not @song.save
  end
  test "should normalise song title, composer and lyricist" do
    @song.save!
    assert_equal @song.title, "Viento Norte"
    assert_equal @song.composer, "Juan D'Arienzo"
    assert_equal @song.lyricist, "Roberto D'el Dia"
  end
end
