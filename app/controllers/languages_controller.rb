class LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy]
  
  http_basic_authenticate_with name: "sasha", password: "tango", except: [:index, :show] if Rails.env.production?
  
  def index
    @languages = Language.all
  end
  
  def new
    @language = Language.new
  end
  
  def create
		@language = Language.new(language_params)
		if @language.save
		  redirect_to @language
    else
      render 'new'
    end
  end
  
	def show
	end
  
  def edit
  end
  
  def update    
		if @language.update(language_params)
		  redirect_to @language
    else
      render 'edit'
    end
  end
  
  def destroy
    @language.destroy
 
    redirect_to languages_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_language
      @language = Language.find(params[:id])
    end
  
    def language_params
      params.require(:language).permit(:iso, :name)
    end
  
end
