class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :iso
      t.integer :translations_count
    end
    
    # Add linking column to translation
    add_reference :translations, :language, index: true, :default => 1    
  end
end
