class Implication < ApplicationRecord
  has_and_belongs_to_many :atoms
  belongs_to :implies, class_name: 'Atom'
end
