class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :name
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
