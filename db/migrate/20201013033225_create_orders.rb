class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user
      t.boolean :design_approval
      t.integer :unit
      t.string :tooth_material
      t.string :design_type
      t.string :turn_around_time
      t.string :model
      t.string :custom_tray
      t.string :rpd_framework
      t.string :abutment_optional
      t.text :message
      t.string :destination
      t.timestamps
    end
  end
end
