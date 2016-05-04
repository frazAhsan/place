class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :domain
      t.string :city
      t.string :state
      t.text :keywords, array: true

      t.timestamps null: false
    end
  end
end
