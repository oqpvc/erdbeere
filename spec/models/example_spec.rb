require 'rails_helper'

RSpec.describe Example, type: :model do
  it 'knows how to derive satisfied properties from example_facts' do
    s = create(:structure)
    b1 = create(:building_block, explained_structure: s)
    b2 = create(:building_block, explained_structure: s)

    e_for_s = create(:example, structure: s.structure)
    e_for_b1 = create(:example, structure: b1.structure)
    e_for_b2 = create(:example, structure: b2.structure)
    BuildingBlockRealization.create(example: e_for_s, building_block: b1, realization: e_for_b1)
    BuildingBlockRealization.create(example: e_for_s, building_block: b2, realization: e_for_b2)

    ps = {}
    as = {}
    [s, b1, b2].each do |i|
      ps[i] = [create(:property, structure: i.structure), create(:property, structure: i.structure)]
      as[i] = [Atom.create(stuff_w_props: i, satisfies: ps[i].first), Atom.create(stuff_w_props: i, satisfies: ps[i].second)]
    end

    ExampleFact.create(example: e_for_b1, property: ps[b1].first, satisfied: true)
    ExampleFact.create(example: e_for_b2, property: ps[b2].first, satisfied: true)
    [as[b1].first, as[b2].first].implies! as[s].first
    expect(e_for_s.satisfies?(as[s].first)).to be(true)
    expect(e_for_s.satisfies?(as[s].second)).to be(false)
  end

  it 'knows how to derive negative properties from example_facts' do
    et = create(:example_fact, satisfied: false)
    a = create(:property, structure: et.example.structure).to_atom
    b = create(:property, structure: et.example.structure).to_atom
    a.implies! b
    b.implies! et.property.to_atom
    expect(et.reload_example.violates?(a)).to be(true)
    expect(et.reload_example.violates?(b)).to be(true)
  end

  it 'knows how to derive satisfied properties from deep atoms' do
    s1 = create(:structure) # like endomorphism
    e_for_s1 = create(:example, structure: s1)
    s2 = create(:structure) # like vector space
    e_for_s2 = create(:example, structure: s2)
    p = create(:property) # like algebraically closed
    s3 = p.structure # like field
    e_for_s3 = create(:example, structure: s3)

    # like underlying vector space of an endomorphism
    bb1 = create(:building_block, explained_structure: s1, structure: s2)
    # like ground field of a vector space
    bb2 = create(:building_block, explained_structure: s2, structure: s3)
    BuildingBlockRealization.create(example: e_for_s1, building_block: bb1, realization: e_for_s2)
    BuildingBlockRealization.create(example: e_for_s2, building_block: bb2, realization: e_for_s3)

    # like trigonizable
    q = create(:property, structure: s1)

    # ground field of a vector space is alg closed
    x = Atom.create(stuff_w_props: bb2, satisfies: p)
    # underlying vs of endo satisfies x
    y = Atom.create(stuff_w_props: bb1, satisfies: x)
    z = Atom.create(stuff_w_props: s1, satisfies: y)

    # if the ground field is alg closed, every endomorphism is trigonizable
    z.implies! q.to_atom

    e_for_s3.satisfies! p
    expect(e_for_s1.satisfies?(q.to_atom)).to be(true)
  end
end
