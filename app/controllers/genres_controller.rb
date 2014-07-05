class GenresController < ApplicationController
  before_action :set_genre, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @genres = Genre.all
  end
  
  def new
    @genre = Genre.new
  end
  
  def create    
		@genre = Genre.new(genre_params)
		respond_to do |format|
      if @genre.save
        format.html { redirect_to @genre, notice: 'Genre was successfully created' }
        format.json { render :show, status: :created, location: @genre }
      else
        format.html { render :new }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end
  
	def show
	end
  
  def edit
  end
  
  def update
		respond_to do |format|
      if @genre.update(genre_params)
        format.html { redirect_to @genre, notice: 'Genre was successfully updated' }
        format.json { render :show, status: :ok, location: @genre }
      else
        format.html { render :new }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @genre.destroy
    respond_to do |format|
      format.html { redirect_to genres_path, notice: 'Genre was successfully destroyed' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions
    def set_genre
      @genre = Genre.find(params[:id])
    end
  
    def genre_params
      params.require(:genre).permit(:name)
    end
  
end
