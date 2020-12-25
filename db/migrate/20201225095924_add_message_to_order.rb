class AddMessageToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :orders, :message, :text
  end
end
