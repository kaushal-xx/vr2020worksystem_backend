class AddDocumentsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :documents, :json
  end
end
