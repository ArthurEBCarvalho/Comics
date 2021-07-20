class AddFavoriteComicsIdsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :favorite_comics_ids, :jsonb, default: []
  end
end
