class CreateTranslators < ActiveRecord::Migration
  def change
    create_table :translators do |t|
      t.string :name
      t.string :site_name
      t.string :site_link
      t.integer :translations_count, :default => 0

      t.timestamps
    end
    
    add_column :translations, :translator_id, :integer, :default => 0
  end
end
