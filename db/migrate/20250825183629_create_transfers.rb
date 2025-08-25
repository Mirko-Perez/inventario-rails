class CreateTransfers < ActiveRecord::Migration[8.0]
  def change
    create_table :transfers do |t|
      t.references :article, null: false, foreign_key: true
      t.references :from_person, null: false, foreign_key: true
      t.references :to_person, null: false, foreign_key: true
      t.date :transfer_date
      t.text :notes

      t.timestamps
    end
  end
end
