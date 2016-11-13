class CreateAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :access_tokens do |t|
      t.string :code
      t.datetime :expires_at
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :access_tokens, :code, unique: true
  end
end
