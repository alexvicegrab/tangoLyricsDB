class TranslationsController < ApplicationController
  
  http_basic_authenticate_with name: "sasha", password: "tango", only: :destroy
  
  def create
    @song = Song.find(params[:song_id])
    @translation = @song.translations.new(translation_params)
    if @translation.save
      flash[:translation_success] = "Thank you for adding a new translation!"
    else
      flash[:translation_error] = @translation.errors.empty? ? "Error" : @translation.errors.full_messages.to_sentence
    end
    redirect_to @song
    
  end
    
  def destroy
    @song = Song.find(params[:song_id])
    @translation = @song.translations.find(params[:id])
    @translation.destroy
    redirect_to @song
  end
 
  private
    def translation_params
      params.require(:translation).permit(:link)
    end
    
end
