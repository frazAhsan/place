class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string :google_place_id
      t.text :detail
      t.string :state
      t.string :city
      t.string :name
      t.string :slug
      t.string :place_id 

      t.timestamps null: false
    end
  end
end
