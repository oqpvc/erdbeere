class Explanation < ApplicationRecord
  belongs_to :explainable, polymorphic: true
end
