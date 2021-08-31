# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @sort_by = params[:sort_by] ? params[:sort_by] : session[:sort_by]
    @ratings = params[:ratings] ? params[:ratings] : session[:ratings]
    @movies = Movie.all

    if (@ratings != nil) then
      if (defined?(@ratings.keys)) then
        @ratings = @ratings.keys
      end
      @movies = @movies.where(:rating => @ratings)
    else
      @ratings = Movie.all_ratings
    end

    if (@sort_by == 'title') then
      @movies = @movies.order(title: :asc)
    elsif (@sort_by == 'release_date') then
      @movies = @movies.order(release_date: :asc)
    end

    session[:sort_by] = @sort_by
    session[:ratings] = @ratings

    @title_header = "title_header_class"
    @release_date_header = "release_date_header_class"
    @all_ratings = Movie.all_ratings
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end