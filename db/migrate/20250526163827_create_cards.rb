class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :title
      t.text :body
      t.integer :position
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
