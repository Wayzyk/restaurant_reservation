class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.date :date, null: false
      t.string :time, null: false
      t.string :duration, null: false

      t.references :restaurant, foreign_key: true, null: false
      t.references :table, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
