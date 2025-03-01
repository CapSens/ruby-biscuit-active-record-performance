class Project < ApplicationRecord
  has_many :subscriptions
  has_many :borrower_terms
end
