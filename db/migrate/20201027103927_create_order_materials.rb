class CreateOrderMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :order_materials do |t|

      t.references :order
      t.integer :unit
      t.string :tooth_material
      t.string :design_type
      t.string :tooth_no
      t.timestamps
    end
  end
end
