class AddSearchTitleToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :search_title, :string
  end
end
