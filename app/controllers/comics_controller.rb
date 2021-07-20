class ComicsController < ApplicationController
  respond_to :json, only: %i[add_favorite remove_favorite]

  def index
    @comics = Marvel::Fetch.comics(fetch_comics_params)
  end

  def add_favorite
    return not_acceptable if comic_params[:comic_id].blank?

    current_user.favorite_comics_ids << comic_params[:comic_id].to_i
    current_user.save!

    render status: :no_content, json: {}
  end

  def remove_favorite
    return not_acceptable if comic_params[:comic_id].blank?

    current_user.favorite_comics_ids.delete(comic_params[:comic_id].to_i)
    current_user.save!

    render status: :no_content, json: {}
  end

  private

  def comic_params
    params.permit(:character, :page, :comic_id)
  end

  def fetch_comics_params
    { character_name: comic_params[:character], page: comic_params[:page] }.compact
  end

  def not_acceptable
    render status: :not_acceptable, json: { message: 'Param comic_id is required' }  
  end
end
