class AddMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :title, null: false, default: '-', index: { unique: true }
      t.text :description, null: false, default: '-'
      t.timestamps

      t.belongs_to :user, index: true, foreign_key: true
      t.index :created_at
    end
  end
end
