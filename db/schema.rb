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


ActiveRecord::Schema.define(version: 20181123151938) do

  create_table "attachments", force: :cascade do |t|
    t.string "name"
    t.string "element_type"
    t.integer "element_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.text "exif"
    t.index ["element_type", "element_id"], name: "index_attachments_on_element_type_and_element_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "message"
    t.integer "post_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tag_id"
    t.integer "weight", default: 0
    t.index ["tag_id"], name: "index_favourites_on_tag_id"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "adder_id"
    t.float "number"
    t.text "description"
    t.string "item_type"
    t.text "enhanced_image"
    t.text "enhanced_content"
  end

  create_table "itemusers", force: :cascade do |t|
    t.integer "item_id"
    t.integer "user_id"
    t.integer "quantity"
    t.datetime "checked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_itemusers_on_item_id"
    t.index ["user_id"], name: "index_itemusers_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "action"
    t.integer "element_id"
    t.integer "user_id"
    t.boolean "done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "element_type"
    t.string "memory"
  end

  create_table "ownertags", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "owner_id"
    t.string "owner_type", default: "Item"
    t.index ["owner_id"], name: "index_ownertags_on_owner_id"
    t.index ["tag_id"], name: "index_ownertags_on_tag_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "message"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "preview_url"
    t.string "preview_title"
    t.text "preview_description"
    t.text "preview_image_url"
    t.string "youtube_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.boolean "root_tag", default: false
    t.string "default_view"
    t.string "letter"
    t.boolean "filter_items", default: true
    t.index ["letter"], name: "index_tags_on_letter"
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer "rights"
    t.datetime "displayed_la_une"
    t.datetime "displayed_collector"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

end
