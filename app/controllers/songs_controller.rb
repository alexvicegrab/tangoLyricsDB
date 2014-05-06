class SongsController < ApplicationController
  
  http_basic_authenticate_with name: "sasha", password: "tango", except: [:index, :show]
  
  def index
    #@songs = Song.all
    @songs = Song.filter(params.slice(:title_contains, :genre_is, :year_min, :year_max))
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
		@song = Song.find(params[:id])
	end
  
  def edit
    @song = Song.find(params[:id])
  end
  
  def update
		@song = Song.find(params[:id])
    
		if @song.update(song_params)
		  redirect_to @song
    else
      render 'edit'
    end
  end
  
  def destroy
    @song = Song.find(params[:id])
    @song.destroy
 
    redirect_to songs_path
  end
  
  private
    def song_params
      params.require(:song).permit(:title, :genre_id, :year, :composer, :lyricist)
    end
  
end