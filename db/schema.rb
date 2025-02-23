# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_22_183536) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "vote_type", ["like", "hate"]

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title", default: "-", null: false
    t.text "description", default: "-", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["created_at"], name: "index_movies_on_created_at"
    t.index ["title"], name: "index_movies_on_title", unique: true
    t.index ["user_id"], name: "index_movies_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.enum "vote_type", null: false, enum_type: "vote_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "movie_id"
    t.index ["movie_id"], name: "index_votes_on_movie_id"
    t.index ["user_id", "movie_id"], name: "index_votes_on_user_id_and_movie_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "movies", "users"
  add_foreign_key "votes", "movies"
  add_foreign_key "votes", "users"

  create_view "aggregated_votes", materialized: true, sql_definition: <<-SQL
      SELECT movies.id AS movie_id,
      movies.user_id,
      movies.created_at,
      count(votes.id) FILTER (WHERE (votes.vote_type = 'like'::vote_type)) AS likes_count,
      count(votes.id) FILTER (WHERE (votes.vote_type = 'hate'::vote_type)) AS hates_count
     FROM (movies
       FULL JOIN votes ON ((movies.id = votes.movie_id)))
    GROUP BY movies.id, movies.user_id, movies.created_at;
  SQL
  add_index "aggregated_votes", ["movie_id"], name: "index_aggregated_votes_on_movie_id", unique: true
  add_index "aggregated_votes", ["user_id", "movie_id"], name: "index_aggregated_votes_on_user_id_and_movie_id", unique: true

end
