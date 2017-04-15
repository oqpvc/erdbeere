class Explanation < ApplicationRecord
  belongs_to :explainable, polymorphic: true

  translates :title, :text, :fallbacks_for_empty_translations => true
  globalize_accessors
end
