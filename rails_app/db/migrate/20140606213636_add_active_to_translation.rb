class AddActiveToTranslation < ActiveRecord::Migration
  def change
    add_column :translations, :active, :boolean, :default => true
  end
end
