class CreateFields < ActiveRecord::Migration[6.1]
  def change
    create_table :fields do |t|
      t.string :name
      t.string :grower
      t.string :farm
      t.geometry :boundary, limit: { type: 'multi_polygon', srid: 4326 }, null: false

      t.timestamps
    end
  end
end
