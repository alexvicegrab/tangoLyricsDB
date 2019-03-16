class LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @languages = Language.includes(:translations).all
  end
  
  def new
    @language = Language.new
  end
  
  def create
		@language = Language.new(language_params)
		respond_to do |format|
      if @language.save
        format.html { redirect_to @language, notice: 'Language was successfully created' }
        format.json { render :show, status: :created, location: @language }
      else
        format.html { render :new }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end
  
	def show
	end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @language.update(language_params)
        format.html { redirect_to @language, notice: 'Language was successfully updated' }
        format.json { render :show, status: :ok, location: @language }
      else
        format.html { render :edit }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @language.destroy
    respond_to do |format|
      format.html { redirect_to languages_path, notice: 'Language was successfully destroyed' }
      format.json { head :no_content }
    end
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
