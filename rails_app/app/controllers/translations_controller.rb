class TranslationsController < ApplicationController
  include UrlHelper
  
  before_action :set_translation, only: [:show, :edit, :update, :destroy, :check_link]
  before_action :authenticate_user!, except: [:index, :show, :create, :check_link]
  
  def inactive
    @translations = Translation.includes([:translator, :language, :song]).where(active: [false, nil]).order(['active', 'songs.title'])
  end
  
  def index
    @translations = Translation.includes([:translator, :language, :song]).filter( params.slice(:language_is, :translator_is )).order('songs.title')
    
    @resultsCount = @translations.count.nil? ? 0 : @translations.count
    
    @translations = @translations.page params[:page]
  end
  
  def show
  end
  
  def create
    @song = Song.find(params[:song_id])
    @translation = @song.translations.new(translation_params)
    
		respond_to do |format|
      if @translation.save
        format.html { redirect_to @song, notice: 'Thank you for adding a new translation!' }
        format.json { render :show, status: :created, location: @translation }
      else
        flash[:error] = @translation.errors.full_messages.to_sentence
        format.html { redirect_to @song }
        format.json { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def check_link
    # @translation.check_link performed inherently during save validation
    @translation.save 
    redirect_to(:back)
  end
  
  def update
    respond_to do |format|
      if @translation.update(translation_params)
        format.html { redirect_to @song, notice: 'Translation was successfully updated' }
        format.json { render :show, status: :ok, location: @translation }
      else
        flash[:error] = @translation.errors.full_messages.to_sentence
        format.html { render :edit }
        format.json { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end
    
  def destroy
    @translation.destroy
    respond_to do |format|
      format.html { redirect_to @song, notice: 'Translation was successfully destroyed' }
      format.json { head :no_content }
    end
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
