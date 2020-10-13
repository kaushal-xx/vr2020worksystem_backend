class AddToothNoColumnToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :orders, :tooth_no, :integer
  end
end
