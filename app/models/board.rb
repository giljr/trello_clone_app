class Board < ApplicationRecord
    has_many :cards, -> { order(:position) }
end
