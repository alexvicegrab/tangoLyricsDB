require 'test_helper'

class SongTest < ActiveSupport::TestCase
  setup do
    @song = songs(:one)
    @song.save
  end
  
  test "song_normalisation" do    
    assert_equal "De Vuelta Al Bulincillo", @song.title
    assert_equal "Juan d'Arienzo", @song.composer
    assert_equal "Enrique Cadicamo", @song.lyricist
  end
end
