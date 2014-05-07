class AddCountToSongsAndTranslations < ActiveRecord::Migration
  def change
    add_column :genres, :songs_count, :integer, :default => 0
    add_column :songs, :translations_count, :integer, :default => 0
  end
end
