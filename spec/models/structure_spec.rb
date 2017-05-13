require 'rails_helper'

RSpec.describe Structure, type: :model do
  it 'correctly passes properties on to children' do
    p = create(:property)
    s = p.structure
    q = create(:property)
    t = q.structure
    expect(t.properties.count).to equal(1)
    t.derives_from = s
    t.save
    expect(t.properties.count).to equal(2)
    expect(s.reload.children.first).to eq(t)
  end

  it 'correctly passes around examples' do
    e1 = create(:example)
    e2 = create(:example)
    s1 = e1.structure
    s2 = e2.structure

    s1.derives_from = s2
    s1.save
    expect(s1.reload.examples.sort == s2.reload.examples.sort).to be(true)

    p = create(:property, structure: s2)
    s1.defining_atoms = [p.to_atom]
    s1.save
    expect(s1.reload.examples.count).to be(1)
    expect(s2.reload.examples.count).to be(2)

    e2.satisfies! p
    expect(s1.reload.examples.count).to be(2)
    expect(s2.reload.examples.count).to be(2)
  end

  it 'correctly uses defining atoms' do
    p = create(:property)
    s = p.structure
    q = create(:property)
    t = q.structure
    t.derives_from = s
    t.defining_atoms = [p.to_atom]
    expect(t.save).to be(true)
  end
end
