class CreateOuraConnections < ActiveRecord::Migration[8.1]
  def change
    create_table :oura_connections do |t|
      t.references :user, null: false, foreign_key: true
      t.text :access_token
      t.text :refresh_token
      t.datetime :expires_at
      t.string :scope

      t.timestamps
    end
  end
end
