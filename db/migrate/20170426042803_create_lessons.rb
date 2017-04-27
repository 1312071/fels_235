class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.boolean :is_finish, default: false
      t.integer :point, default: 0
      t.timestamps
    end
    add_index :lessons, [:user_id, :category_id]
  end
end
