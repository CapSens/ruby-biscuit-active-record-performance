class CreateLenderTerms < ActiveRecord::Migration[8.0]
  def change
    create_table :lender_terms do |t|
      t.references :borrower_term, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.date :due_date
      t.integer :amount_to_pay

      t.timestamps
    end
  end
end
