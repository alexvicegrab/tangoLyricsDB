class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :iso
      t.string :name
      t.integer :translations_count, :default => 0
      t.timestamps
    end
    
    # Add linking column to translation
    add_reference :translations, :language, index: true, :default => 1
  end
end
