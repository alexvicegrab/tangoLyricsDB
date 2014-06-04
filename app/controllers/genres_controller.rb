class GenresController < ApplicationController
  before_action :set_genre, only: [:show, :edit, :update, :destroy]
  
  http_basic_authenticate_with name: "sasha", password: "tango", except: [:index, :show] if Rails.env.production?
  
  def index
    @genres = Genre.all
  end
  
  def new
    @genre = Genre.new
  end
  
  def create    
		@genre = Genre.new(genre_params)
		if @genre.save
		  redirect_to @genre
    else
      render 'new'
    end
  end
  
	def show
	end
  
  def edit
  end
  
  def update
		if @genre.update(genre_params)
		  redirect_to @genre
    else
      render 'edit'
    end
  end
  
  def destroy
    @genre.destroy
 
    redirect_to genres_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_genre
      @genre = Genre.find(params[:id])
    end
  
    def genre_params
      params.require(:genre).permit(:name)
    end
  
end
