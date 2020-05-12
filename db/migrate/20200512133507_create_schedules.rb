class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.string :day, null: false
      t.string :start_at, null: false
      t.string :end_at, null: false

      t.references :restaurant, foreign_key: true, null: false

      t.timestamps
    end
  end
end
