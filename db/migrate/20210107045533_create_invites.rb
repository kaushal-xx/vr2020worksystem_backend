class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.references :order
      t.references :user
      t.timestamps
    end
  end
end
