class InitialSchema < ActiveRecord::Migration
  def change
    create_table :portals do |t|
      t.string :name, limit: 50
      t.string :imageUrl
      t.integer :latitude
      t.integer :longitude
      t.string :googlePlaceId, limit: 50
      t.timestamps
    end
  end
end
