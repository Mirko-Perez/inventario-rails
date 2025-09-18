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

ActiveRecord::Schema[8.0].define(version: 2025_09_17_181743) do
  create_table "articles", force: :cascade do |t|
    t.string "model"
    t.string "brand"
    t.date "entry_date"
    t.integer "current_person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["current_person_id"], name: "index_articles_on_current_person_id"
    t.index ["deleted_at"], name: "index_articles_on_deleted_at"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_people_on_deleted_at"
  end

  create_table "transfers", force: :cascade do |t|
    t.integer "article_id", null: false
    t.integer "from_person_id", null: false
    t.integer "to_person_id", null: false
    t.date "transfer_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["article_id"], name: "index_transfers_on_article_id"
    t.index ["deleted_at"], name: "index_transfers_on_deleted_at"
    t.index ["from_person_id"], name: "index_transfers_on_from_person_id"
    t.index ["to_person_id"], name: "index_transfers_on_to_person_id"
  end

  add_foreign_key "articles", "people", column: "current_person_id"
  add_foreign_key "transfers", "articles"
  add_foreign_key "transfers", "people", column: "from_person_id"
  add_foreign_key "transfers", "people", column: "to_person_id"
end
