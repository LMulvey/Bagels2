class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.references :user, foreign_key: true
      t.string :description
      t.integer :status, default: 0 # 0 = Active, 1 = Completed
      t.datetime :completed_at
      t.timestamps
    end
  end
end
