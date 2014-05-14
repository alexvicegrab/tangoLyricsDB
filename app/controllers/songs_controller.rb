class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  
  http_basic_authenticate_with name: "sasha", password: "tango", except: [:index, :show]
  
  def index
    #@songs = Song.all
    @songs = Song.filter( params.slice(:title_has, :genre_is, :composer_has, :lyricist_has, :year_min, :year_max, :translation_num, :language_is ))
    # Do not repeat records
    @songs = @songs.distinct
  end
  
  def new
    @song = Song.new
  end
  
  def create
    # Display the hash
    #render plain: params[:song].inspect
    
		@song = Song.new(song_params)
		if @song.save
		  redirect_to @song
    else
      render 'new'
    end
  end
  
	def show
	end
  
  def edit
  end
  
  def update
		if @song.update(song_params)
		  redirect_to @song
    else
      render 'edit'
    end
  end
  
  def destroy
    @song.destroy
 
    redirect_to songs_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end
  
    def song_params
      params.require(:song).permit(:title, :genre_id, :year, :composer, :lyricist)
    end
  
end
