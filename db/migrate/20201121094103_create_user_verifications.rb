class CreateUserVerifications < ActiveRecord::Migration[6.0]
  def change
    create_table :user_verifications do |t|
      t.references :user
      t.string :email
      t.string :token
      t.boolean :verified
      t.timestamps
    end
  end
end
