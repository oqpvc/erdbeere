require 'faker'

FactoryGirl.define do
  factory :structure do
    name { Faker::RickAndMorty.character }
    definition { Faker::RickAndMorty.quote }
  end

  factory :building_block do
    name { Faker::Beer.name }
    definition { Faker::ChuckNorris.fact }
    association :explained_structure, factory: :structure
    structure
  end

  factory :property do
    name { Faker::SlackEmoji.people }
    structure
  end

  factory :atom do
    trait :of_structure do
      association :stuff_w_props, factory: :structure
    end

    trait :of_bb do
      association :stuff_w_props, factory: :building_block
    end

    before(:create) do |a|
      a.satisfies = FactoryGirl.create(:property, structure: a.stuff_w_props.structure)
    end
  end

  factory :example do
    description { Faker::Hipster.paragraph }
    structure
  end

  factory :example_fact do
    satisfied { Faker::Boolean.boolean }
    example
    before(:create) do |et|
      et.property = FactoryGirl.create(:property, structure: et.example.structure)
    end
  end
end
