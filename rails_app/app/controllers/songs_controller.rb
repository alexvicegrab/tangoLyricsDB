class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @songs = Song.includes(:genre, :translations).filter( params.slice(:title_has,
    :genre_is, 
    :composer_has, 
    :lyricist_has, 
    :year_min, 
    :year_max, 
    :translation_num, 
    :language_is,
    :translator_is ))
    # Do not repeat records
    @songs = @songs.distinct
    
    @resultsCount = @songs.count.nil? ? 0 : @songs.count
    
    @songs = @songs.page params[:page]
  end
  
  def new
    @song = Song.new
  end
  
  def create
    # Display the hash
    #render plain: params[:song].inspect
    
    @song = Song.new(song_params)
    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_path, notice: 'Song was successfully destroyed' }
      format.json { head :no_content }
    end
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
