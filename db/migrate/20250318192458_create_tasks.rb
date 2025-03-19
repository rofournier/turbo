class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.string :color
      t.boolean :running, default: true
      t.integer :time_spent, default: 0
      t.boolean :completed, default: false
      t.datetime :last_started_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
