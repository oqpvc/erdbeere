require "rails_helper"

RSpec.describe ExampleFact, type: :model do
  it 'tests if example and property type-match' do
    s1 = create(:structure)
    p1 = create(:property, structure: s1)
    e1 = create(:example, structure: s1)

    s2 = create(:structure)
    p2 = create(:property, structure: s2)
    e2 = create(:example, structure: s2)

    expect(ExampleFact.create({example: e1, property: p2, satisfied: true}).save).to be(false)
    expect(ExampleFact.create({example: e2, property: p1, satisfied: true}).save).to be(false)
    expect(ExampleFact.create({example: e1, property: p1, satisfied: true}).save).to be(true)
    expect(ExampleFact.create({example: e2, property: p2, satisfied: true}).save).to be(true)
  end

  # it "doesn't allow falsehoods that already follow from previous data" do
  #   s = create(:structure)
  #   p1 = create(:property, structure: s)
  #   p2 = create(:property, structure: s)
  #   p1.to_atom.implies! p2.to_atom

  #   e = create(:example, structure: s)
  #   expect(ExampleFact.create({example: e, property: p1, satisfied: true}).save).to be(true)
  #   expect(ExampleFact.create({example: e, property: p2, satisfied: false}).save).to be(false)
  # end

  it "doesn't allow duplicates" do
    s = create(:structure)
    p = create(:property, structure: s)
    e = create(:example, structure: s)
    expect(ExampleFact.create({example: e, property: p, satisfied: false}).save).to be(true)
    expect(ExampleFact.create({example: e, property: p, satisfied: false}).save).to be(false)
  end
end
