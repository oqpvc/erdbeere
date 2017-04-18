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
    [as[s].first, as[b1].first].implies! as[b2].first
    [as[b2].first, as[b1].first].implies! as[s].first
    [as[s].first, as[b2].first].implies! as[b1].first


    expect(as[s].first.follows_from?(as[b1].first, as[b2].first)).to be(true)
    expect(as[b1].first.follows_from?(as[s].first, as[b2].first)).to be(true)
    expect(as[b2].first.follows_from?(as[s].first, as[b1].first)).to be(true)
    expect(as[s].first.follows_from?(as[b1].first)).to be(false)

    [as[b2].first, as[b2].second].implies! as[s].second
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

  it "tests that stuff_w_props and property are of the same structure" do
    s1 = create(:structure)
    p1 = create(:property, structure: s1)
    s2 = create(:structure)
    p2 = create(:property, structure: s2)

    fail1 = Atom.create({stuff_w_props: s1, property: p2})
    fail2 = Atom.create({stuff_w_props: s2, property: p1})

    expect(fail1.save).to be(false)
    expect(fail2.save).to be(false)

    success1 = Atom.create({stuff_w_props: s1, property: p1})
    success2 = Atom.create({stuff_w_props: s2, property: p2})

    expect(success1.save).to be(true)
    expect(success2.save).to be(true)
  end
end
