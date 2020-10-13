class AddDocumentColumnToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :orders, :document, :string
  	add_column :orders, :stl_file, :string
  end
end
