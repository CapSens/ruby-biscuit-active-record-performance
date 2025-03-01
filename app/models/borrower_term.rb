class BorrowerTerm < ApplicationRecord
  belongs_to :project

  has_many :lender_terms
end
