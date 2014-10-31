class CreatePortals < ActiveRecord::Migration
  def change
    create_table :portals do |t|
      t.string :name, limit: 20
      t.string :imageUrl, limit: 50
      t.integer :latitude
      t.integer :longitude
      t.timestamps
    end
  end
end
