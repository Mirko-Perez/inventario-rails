class AddDeletedAtToArticlesAndPeople < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :deleted_at, :datetime
    add_column :people, :deleted_at, :datetime

    add_index :articles, :deleted_at
    add_index :people, :deleted_at
  end
end
