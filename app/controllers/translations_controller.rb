class TranslationsController < ApplicationController
  
  http_basic_authenticate_with name: "sasha", password: "tango", only: :destroy
  
  def create
    @song = Song.find(params[:song_id])
    @translation = @song.translations.create(translation_params)
    redirect_to song_path(@song)
  end
    
  def destroy
    @song = Song.find(params[:song_id])
    @translation = @song.translations.find(params[:id])
    @translation.destroy
    redirect_to song_path(@song)
  end
 
  private
    def translation_params
      params.require(:translation).permit(:link)
    end
    
end
