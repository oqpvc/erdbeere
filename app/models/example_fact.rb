class NoImmediateContradiction < ActiveModel::Validator
  def validate(obj)
    return if obj.satisfied != false
    return unless obj.example.satisfied_atoms.include?(obj.property.to_atom)
    obj.errors[:base] << "property #{obj.property.name} is already satisfied,"
    obj.errors[:base] << "can't hardcode to false."
  end
end

class ExampleFact < ApplicationRecord
  belongs_to :example, touch: true
  belongs_to :property

  validates :example, presence: true
  validates :property, presence: true, uniqueness: { scope: :example }
  validates :satisfied, inclusion: { in: [true, false] }
  validates_with EqualityTest, a: 'example.structure', b: 'property.structure'
  validates_with NoImmediateContradiction

  def violated?
    if satisfied.nil?
      nil
    else
      !satisfied
    end
  end

  def satisfied?
    satisfied
  end
end
