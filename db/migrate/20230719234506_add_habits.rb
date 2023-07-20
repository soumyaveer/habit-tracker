class AddHabits < ActiveRecord::Migration[7.0]
  def change
    create_table :habits do |t|
      t.string :name, null: false
      t.string :status, null: true
      t.bigint :completed_at, null: true
      t.bigint :completed_before, null: false
      t.timestamps
    end
  end
end
