class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :ticket, foreign_key: true
      t.references :user, foreign_key:true
      t.integer :event_type, null: false
      t.integer :measurement
      t.string :measurement_type

      t.timestamps
    end
  end
end
