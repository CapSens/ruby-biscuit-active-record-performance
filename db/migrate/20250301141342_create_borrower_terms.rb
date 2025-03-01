class CreateBorrowerTerms < ActiveRecord::Migration[8.0]
  def change
    create_table :borrower_terms do |t|
      t.references :project, null: false, foreign_key: true
      t.date :due_date
      t.integer :amount_to_pay

      t.timestamps
    end
  end
end
