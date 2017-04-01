class Conjunction < ApplicationRecord
  has_and_belongs_to_many :atoms
end
