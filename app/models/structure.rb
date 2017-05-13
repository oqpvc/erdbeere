class Structure < ApplicationRecord
  has_many :original_properties, class_name: 'Property'
  has_many :original_examples, class_name: 'Example'

  has_many :original_building_blocks, foreign_key: 'explained_structure_id',
             inverse_of: :explained_structure, class_name: 'BuildingBlock'

  has_many :atoms, as: :stuff_w_props
  belongs_to :derives_from, class_name: 'Structure', foreign_key: 'derives_from_id'

  has_many :children, class_name: 'Structure', foreign_key: 'derives_from_id',
           inverse_of: :derives_from

  has_many :axioms
  has_many :defining_atoms, through: :axioms, source: :atom

  after_commit :touch_examples

  translates :name, :definition, fallbacks_for_empty_translations: true
  globalize_accessors

  def structure
    self
  end

  def properties
    return original_properties if derives_from.nil?
    original_properties + derives_from.properties
  end

  def building_blocks
    return original_building_blocks if derives_from.nil?
    original_building_blocks + derives_from.building_blocks
  end

  def related_structures
    result = []
    tmp = [self]
    while result != tmp
      result = tmp
      tmp += tmp.map(&:derives_from).flatten.compact
      tmp += tmp.map(&:children).flatten.compact
      tmp = tmp.flatten.compact.uniq
    end
    result
  end

  def examples
    related_structures.map(&:original_examples).flatten.find_all do |e|
      (defining_atoms - e.satisfied_atoms).empty?
    end
  end

  def touch_examples
    (examples + original_examples).uniq.map(&:touch)
  end
end
