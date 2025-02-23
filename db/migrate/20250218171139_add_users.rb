class AddUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :email, null: false
      t.string :password_digest
      t.timestamps
    end
  end
end
