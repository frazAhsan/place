class AddLatitudeAndLongitudeToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :latitude, :float
    add_column :domains, :longitude, :float
  end
end
