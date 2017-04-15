require "rails_helper"

RSpec.describe Example, type: :model do
  it "knows how to handle implications" do
    s = create(:structure)
    b1 = create(:building_block, explained_structure: s)
    b2 = create(:building_block, explained_structure: s)

    e_for_s = create(:example, structure: s.structure)
    e_for_b1 = create(:example, structure: b1.structure)
    e_for_b2 = create(:example, structure: b2.structure)
    BuildingBlockRealization.create({example: e_for_s, building_block: b1, realization: e_for_b1})
    BuildingBlockRealization.create({example: e_for_s, building_block: b2, realization: e_for_b2})

    ps = {}
    as = {}
    [s, b1, b2].each do |i|
      ps[i] = [create(:property, structure: i.structure), create(:property, structure: i.structure)]
      as[i] = [Atom.create({stuff_w_props: i, property: ps[i].first}), Atom.create({stuff_w_props: i, property: ps[i].second})]
    end

    ExampleTruth.create({example: e_for_b1, property: as[b1].first.property, satisfied: true})
    ExampleTruth.create({example: e_for_b2, property: as[b2].first.property, satisfied: true})

    expect(e_for_s.satisfies?(as[s].first)).to be(false)

    Implication.create({atoms: [as[b2].first, as[b1].first], implies: as[s].first})

    expect(e_for_s.satisfies?(as[s].first)).to be(true)
    expect(e_for_s.satisfies?(as[s].second)).to be(false)
  end
end
