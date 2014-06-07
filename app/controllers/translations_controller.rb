class TranslationsController < ApplicationController
  include UrlHelper
  
  before_action :set_translation, only: [:show, :edit, :update, :destroy, :check_link]
  
  http_basic_authenticate_with name: "sasha", password: "tango", except: [:index, :show, :create, :check_link] if Rails.env.production?
  
  def inactive
    @translations = Translation.all
    @translations = @translations.where(active: [false, nil])
  end
  
  def show
  end
  
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
  
  def check_link
    # Check if link is working
    @translation.save # @translation.check_link performed inherently during save validation
    redirect_to(:back)
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
