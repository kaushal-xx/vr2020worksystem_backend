class AddAddressColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :address1, :text
    add_column :users, :address2, :text
    add_column :users, :country, :string
    add_column :users, :state, :string
    add_column :users, :zip_code, :string
    add_column :users, :stl_files, :text, array:true, default: []
  end
end
