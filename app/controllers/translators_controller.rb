class TranslatorsController < ApplicationController
  before_action :set_translator, only: [:show, :edit, :update, :destroy]
  
  http_basic_authenticate_with name: "sasha", password: "tango", except: [:index, :show]
  
  def index
    @translators = Translator.all
  end

  def show
  end

  def new
    @translator = Translator.new
  end

  def edit
  end

  # Auto-created from scaffold, uses JSON formats
  def create
    @translator = Translator.new(translator_params)

    respond_to do |format|
      if @translator.save
        format.html { redirect_to @translator, notice: 'Translator was successfully created.' }
        format.json { render :show, status: :created, location: @translator }
      else
        format.html { render :new }
        format.json { render json: @translator.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @translator.update(translator_params)
        format.html { redirect_to @translator, notice: 'Translator was successfully updated.' }
        format.json { render :show, status: :ok, location: @translator }
      else
        format.html { render :edit }
        format.json { render json: @translator.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @translator.destroy
    respond_to do |format|
      format.html { redirect_to translators_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_translator
      @translator = Translator.find(params[:id])
    end

    def translator_params
      params.require(:translator).permit(:name, :site_name, :site_link)
    end
end
