class CreateAggregatedVotes < ActiveRecord::Migration[8.0]
  def change
    create_view :aggregated_votes, materialized: true

    add_index :aggregated_votes, :movie_id, unique: true
    add_index :aggregated_votes, %i[user_id movie_id], unique: true
  end
end
