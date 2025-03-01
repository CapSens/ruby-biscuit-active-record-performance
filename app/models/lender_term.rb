class LenderTerm < ApplicationRecord
  belongs_to :borrower_term
  belongs_to :subscription
end
