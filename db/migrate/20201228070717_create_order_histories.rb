class CreateOrderHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :order_histories do |t|
      t.references :order
      t.jsonb :old_data
      t.jsonb :new_data
      t.integer :version
      t.timestamps
    end
  end
end
