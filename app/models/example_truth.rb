class ExampleTruth < ApplicationRecord
  belongs_to :example
  belongs_to :property

  validates :example, presence: true
  validates :property, presence: true
  validates_with EqualityTest, a: 'example.structure', b: 'property.structure'

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
