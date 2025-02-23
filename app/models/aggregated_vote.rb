# frozen_string_literal: true

class AggregatedVote < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  def self.refresh
    # concurrent: true is not supported because no unique index is present in the view
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
