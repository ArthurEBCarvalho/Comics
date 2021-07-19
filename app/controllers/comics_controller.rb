class ComicsController < ApplicationController
  def index
    @comics = Marvel::Fetch.comics(fetch_comics_params)
  end

  private

  def comic_params
    params.permit(:character, :page)
  end

  def fetch_comics_params
    { character_name: comic_params[:character], page: comic_params[:page] }.compact
  end
end
