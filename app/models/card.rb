class Card < ApplicationRecord
  belongs_to :board
  acts_as_list scope: :board
end
