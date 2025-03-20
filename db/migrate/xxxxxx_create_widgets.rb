class CreateWidgets < ActiveRecord::Migration[7.0]
  def change
    create_table :widgets do |t|
      t.string :name, null: false
      t.boolean :visible, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :widgets, [:name, :user_id], unique: true
  end
end
