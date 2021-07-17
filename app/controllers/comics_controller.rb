class ComicsController < ApplicationController
  def index
    @comics = Marvel::Fetch.comics(comic_params[:character])
  end

  private

  def comic_params
    params.permit(:character)
  end
end
