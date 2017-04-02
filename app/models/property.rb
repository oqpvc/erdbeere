class Property < ApplicationRecord
  belongs_to :structure

  validates :structure, presence: true
end
