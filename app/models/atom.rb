class Atom < ApplicationRecord
  # TODO validations
  has_and_belongs_to_many :implications

  belongs_to :stuff_w_props, polymorphic: true
  belongs_to :property
end
