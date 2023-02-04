class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.float :bonuses, default: 0
      t.references :user, foreign_key: true
      t.references :shop, foreign_key: true

      t.timestamps
    end
  end
end
