class AddVotes < ActiveRecord::Migration[8.0]
  def change
    execute <<~SQL
      CREATE TYPE vote_type AS ENUM ('like', 'hate');
    SQL

    create_table :votes do |t|
      t.column :vote_type, :vote_type, null: false
      t.timestamps

      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :movie, index: true, foreign_key: true
      t.index %i[user_id movie_id], unique: true
    end
  end
end
