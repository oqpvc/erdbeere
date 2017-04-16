require "rails_helper"

RSpec.describe ExampleTruth, type: :model do
  it 'tests if example and property type-match' do
    s1 = create(:structure)
    p1 = create(:property, structure: s1)
    e1 = create(:example, structure: s1)

    s2 = create(:structure)
    p2 = create(:property, structure: s2)
    e2 = create(:example, structure: s2)

    expect(ExampleTruth.create({example: e1, property: p2, satisfied: true}).save).to be(false)
    expect(ExampleTruth.create({example: e2, property: p1, satisfied: true}).save).to be(false)
    expect(ExampleTruth.create({example: e1, property: p1, satisfied: true}).save).to be(true)
    expect(ExampleTruth.create({example: e2, property: p2, satisfied: true}).save).to be(true)
  end
end
