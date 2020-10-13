class AddStatusColumnToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :client_name, :string
  	add_column :orders, :status, :string, default: 'draft'
  end
end
