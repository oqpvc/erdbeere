class Premise < ActiveRecord::Base
  belongs_to :atom
  belongs_to :implication
end
