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

ActiveRecord::Schema.define(version: 20170427031727) do

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

  create_table "series", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "country"
    t.integer  "seasons"
    t.integer  "chapters_duration"
    t.float    "rating"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "role"
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

end
