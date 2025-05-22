class Question < ApplicationRecord
  belongs_to :website
  has_one :answer, dependent: :destroy
end
