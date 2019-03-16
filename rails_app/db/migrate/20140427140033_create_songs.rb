class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.string :composer
      t.string :lyricist

      t.timestamps
    end
  end
end
