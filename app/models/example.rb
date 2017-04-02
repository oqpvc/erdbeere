class Example < ApplicationRecord
  has_many :example_truths
  belongs_to :structure
  has_many :explanations, as: :explainable

  validates :structure, presence: true

  def satisfied
    @example_truths.find_all { |t| t.satisfied == true }.map { |t| t.property }
  end

  def violated
    @example_truths.find_all { |t| t.satisfied == false }.map { |t| t.property }
  end
end
