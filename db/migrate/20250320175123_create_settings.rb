class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.json :config, null: false, default: {}
      t.timestamps
    end
  end
end
