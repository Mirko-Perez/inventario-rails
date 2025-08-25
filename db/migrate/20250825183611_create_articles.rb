class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :model
      t.string :brand
      t.date :entry_date
      t.references :current_person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
