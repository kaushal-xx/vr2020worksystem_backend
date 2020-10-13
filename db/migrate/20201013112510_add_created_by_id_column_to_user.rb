class AddCreatedByIdColumnToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :created_by_id, :integer
  end
end
