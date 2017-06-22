# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170621030126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actors", force: :cascade do |t|
    t.string   "name"
    t.string   "nacionality"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "actors_series", id: false, force: :cascade do |t|
    t.integer "series_id", null: false
    t.integer "actor_id",  null: false
    t.index ["actor_id"], name: "index_actors_series_on_actor_id", using: :btree
    t.index ["series_id", "actor_id"], name: "index_actors_series_on_series_id_and_actor_id", unique: true, using: :btree
    t.index ["series_id"], name: "index_actors_series_on_series_id", using: :btree
  end

  create_table "chapters", force: :cascade do |t|
    t.string   "name"
    t.integer  "rating"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "chapter_number"
    t.integer  "season_id"
    t.integer  "duration"
    t.string   "description"
    t.date     "release_date"
    t.index ["season_id", "chapter_number"], name: "index_chapters_on_season_id_and_chapter_number", unique: true, using: :btree
    t.index ["season_id"], name: "index_chapters_on_season_id", using: :btree
  end

  create_table "chapters_ratings", force: :cascade do |t|
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_chapters_ratings_on_chapter_id", using: :btree
    t.index ["user_id"], name: "index_chapters_ratings_on_user_id", using: :btree
  end

  create_table "chapters_users", id: false, force: :cascade do |t|
    t.integer "chapter_id", null: false
    t.integer "user_id",    null: false
    t.index ["chapter_id", "user_id"], name: "index_chapters_users_on_chapter_id_and_user_id", unique: true, using: :btree
    t.index ["chapter_id"], name: "index_chapters_users_on_chapter_id", using: :btree
    t.index ["user_id"], name: "index_chapters_users_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "series_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["series_id"], name: "index_comments_on_series_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "directors", force: :cascade do |t|
    t.string   "name"
    t.string   "nacionality"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "directors_series", id: false, force: :cascade do |t|
    t.integer "series_id",   null: false
    t.integer "director_id", null: false
    t.index ["director_id"], name: "index_directors_series_on_director_id", using: :btree
    t.index ["series_id", "director_id"], name: "index_directors_series_on_series_id_and_director_id", unique: true, using: :btree
    t.index ["series_id"], name: "index_directors_series_on_series_id", using: :btree
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "favorable_id"
    t.string   "favorable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["favorable_id"], name: "index_favorites_on_favorable_id", using: :btree
    t.index ["user_id", "favorable_id", "favorable_type"], name: "index_favorites_on_user_id_and_favorable_id_and_favorable_type", unique: true, using: :btree
    t.index ["user_id"], name: "index_favorites_on_user_id", using: :btree
  end

  create_table "genders", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genders_series", id: false, force: :cascade do |t|
    t.integer "series_id", null: false
    t.integer "gender_id", null: false
    t.index ["gender_id"], name: "index_genders_series_on_gender_id", using: :btree
    t.index ["series_id", "gender_id"], name: "index_genders_series_on_series_id_and_gender_id", unique: true, using: :btree
    t.index ["series_id"], name: "index_genders_series_on_series_id", using: :btree
  end

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_news_on_user_id", using: :btree
  end

  create_table "seasons", force: :cascade do |t|
    t.integer  "number"
    t.integer  "series_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["series_id"], name: "index_seasons_on_series_id", using: :btree
  end

  create_table "series", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "country"
    t.integer  "seasons"
    t.integer  "chapters_duration"
    t.float    "rating"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.date     "release_date"
    t.index ["user_id"], name: "index_series_on_user_id", using: :btree
  end

  create_table "series_ratings", force: :cascade do |t|
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "series_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["series_id"], name: "index_series_ratings_on_series_id", using: :btree
    t.index ["user_id"], name: "index_series_ratings_on_user_id", using: :btree
  end

  create_table "series_users", id: false, force: :cascade do |t|
    t.integer "series_id", null: false
    t.integer "user_id",   null: false
    t.index ["series_id", "user_id"], name: "index_series_users_on_series_id_and_user_id", unique: true, using: :btree
    t.index ["series_id"], name: "index_series_users_on_series_id", using: :btree
    t.index ["user_id"], name: "index_series_users_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.string   "role"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.integer  "father_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "chapters", "seasons"
  add_foreign_key "chapters_ratings", "chapters"
  add_foreign_key "chapters_ratings", "users"
  add_foreign_key "comments", "series"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "users"
  add_foreign_key "news", "users"
  add_foreign_key "seasons", "series"
  add_foreign_key "series", "users"
  add_foreign_key "series_ratings", "series"
  add_foreign_key "series_ratings", "users"
end
