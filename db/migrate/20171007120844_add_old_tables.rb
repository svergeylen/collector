class AddOldTables < ActiveRecord::Migration[5.1]
  def change

	  create_table "bd_auteurs", primary_key: "aid", id: :integer, limit: 3, force: :cascade do |t|
	    t.string "nom", limit: 50, default: "", null: false
	  end

	  create_table "bd_bd", primary_key: "bdid", id: :integer, limit: 3, force: :cascade do |t|
	    t.integer "sid", limit: 3, default: 0, null: false
	    t.string "titre", limit: 100, default: "", null: false
	    t.integer "numero", limit: 2, default: 0, null: false
	    t.integer "datedajout", default: 1198486315, null: false
	    t.integer "par", limit: 3, default: 0, null: false
	    t.integer "PID1", limit: 1, default: 0, null: false
	    t.integer "PID2", limit: 1, default: 0, null: false
	    t.integer "PID9", limit: 1, default: 0, null: false
	    t.integer "PID23", limit: 1, default: 0, null: false
	  end

	  create_table "bd_bdaid", id: :integer, force: :cascade do |t|
	    t.integer "bdid", null: false
	    t.integer "aid", null: false
	    t.index ["bdid", "aid"], name: "bdid"
	    t.index ["id"], name: "id", unique: true
	  end

	  create_table "bd_membres", primary_key: "pid", id: :integer, limit: 3, force: :cascade do |t|
	    t.string "cle", limit: 32, default: "", null: false
	    t.string "login", limit: 30, default: "", null: false
	    t.string "password", limit: 35, default: "", null: false
	    t.string "nom", limit: 70, default: "", null: false
	    t.text "amis", limit: 16777215, null: false
	    t.boolean "admin", default: false, null: false
	  end

	  create_table "bd_prets", id: :integer, force: :cascade do |t|
	    t.integer "bdid", null: false
	    t.string "texte", null: false
	    t.timestamp "date", default: -> { "CURRENT_TIMESTAMP" }, null: false
	    t.integer "pid", null: false
	  end

	  create_table "bd_series", primary_key: "sid", id: :integer, limit: 3, force: :cascade do |t|
	    t.string "nom", limit: 50, default: "", null: false
	    t.string "lettre", limit: 1, default: "", null: false
	    t.integer "PID1", limit: 1, default: 0, null: false
	    t.integer "PID2", limit: 1, default: 0, null: false
	    t.integer "PID9", limit: 1, default: 0, null: false
	    t.integer "PID23", limit: 1, default: 0, null: false
	  end




  end
end
