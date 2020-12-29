class AddColumnComMessageToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :orders, :com_message, :text
  end
end
