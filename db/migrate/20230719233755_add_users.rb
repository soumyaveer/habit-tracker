# frozen_string_literal: true

class AddUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name, null: true
      t.string :password_digest, null: false
      t.bigint :disabled_at, null: true
      t.timestamps
    end
  end
end
