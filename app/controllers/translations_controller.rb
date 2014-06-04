class TranslationsController < ApplicationController
  before_action :set_translation, only: [:edit, :update, :destroy]
  
  http_basic_authenticate_with name: "sasha", password: "tango", except: [:index, :show, :create]
  
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
  
  def edit
  end
  
  def update
    if @translation.update(translation_params)
      flash[:translation_success] = "Thank you for updating the translation!"
      redirect_to @song
    else
      flash[:translation_error] = @translation.errors.empty? ? "Error" : @translation.errors.full_messages.to_sentence
      render 'edit'
    end
  end
    
  def destroy
    @translation.destroy
    redirect_to @song
  end
 
  private
    def set_translation
      @song = Song.find(params[:song_id])
      @translation = @song.translations.find(params[:id])
    end
  
    def translation_params
      params.require(:translation).permit(:link, :language_id)
    end
    
end
