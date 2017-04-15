require "rails_helper"

RSpec.describe Atom, type: :model do
  it "can perform simple implications" do
    s = create(:structure)
    b1 = create(:building_block, explained_structure: s)
    b2 = create(:building_block, explained_structure: s)

    ps = {}
    as = {}
    [s, b1, b2].each do |i|
      ps[i] = [create(:property, structure: i.structure), create(:property, structure: i.structure)]
      as[i] = [Atom.create({stuff_w_props: i, property: ps[i].first}), Atom.create({stuff_w_props: i, property: ps[i].second})]
    end

    # if two out of three have something, then the third has something
    Implication.create({atoms: [as[s].first, as[b1].first], implies: as[b2].first})
    Implication.create({atoms: [as[b2].first, as[b1].first], implies: as[s].first})
    Implication.create({atoms: [as[s].first, as[b2].first], implies: as[b1].first})

    expect(as[s].first.follows_from?(as[b1].first, as[b2].first)).to be(true)
    expect(as[s].first.follows_from?(as[b1].first)).to be(false)

    Implication.create({atoms: [as[b2].first, as[b2].second], implies: as[s].second})
    expect(as[s].second.follows_from?(as[b1].first, as[s].first)).to be(false)
    expect(as[s].second.follows_from?(as[b1].first, as[s].first, as[b2].second)).to be(true)
  end
  it "doesn't allow duplicates" do
    [:of_structure, :of_bb].each do |type|
      a = create(:atom, :of_structure)
      b = Atom.create({stuff_w_props: a.stuff_w_props, property: a.property})
      expect(b.save).to be(false)
    end
  end
end
