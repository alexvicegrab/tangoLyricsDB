class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.string :link
      
      # this line adds an integer column called `song_id`
      t.references :song, index: true

      t.timestamps
    end
  end
end
