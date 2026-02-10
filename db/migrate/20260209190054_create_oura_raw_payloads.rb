class CreateOuraRawPayloads < ActiveRecord::Migration[8.1]
  def change
    create_table :oura_raw_payloads do |t|
      t.references :user, null: false, foreign_key: true
      t.string :data_type, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.jsonb :payload, null: false, default: {}

      t.timestamps
    end

    add_index :oura_raw_payloads, [:user_id, :data_type, :start_date, :end_date], unique: true, name: "index_oura_raw_range"
  end
end
