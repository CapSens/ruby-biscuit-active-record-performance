class Subscription < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_many :lender_terms
end
