class SaneExampleTruths < ActiveModel::Validator
  def validate(et)
    if et.example.structure != property.structure
      et.errors[:base] << "Mismatch between example and property in example_truth"
    end
  end
end

class ExampleTruth < ApplicationRecord
  belongs_to :example
  belongs_to :property

  validates :example, presence: true
  validates :property, presence: true
  validates_with SaneExampleTruths

  def violated?
    if satisfied.nil?
      nil
    else
      not satisfied
    end
  end

  def satisfied?
    satisfied
  end
end
