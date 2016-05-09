class CreateGooglePlaces < ActiveRecord::Migration
  def change
    create_table :google_places do |t|
      t.integer :domain_id
      t.string :place_id
      t.text :detail
      t.string :state
      t.string :city
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
  end
end
