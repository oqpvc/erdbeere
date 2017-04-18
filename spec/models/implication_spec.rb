require 'rails_helper'

RSpec.describe Atom, type: :model do
  it "doesn't allow duplicates" do
    atoms = (1..3).map do |_i|
      create(:atom, :of_structure)
    end
    success1 = Implication.create(atoms: [atoms.first], implies: atoms.second)
    expect(success1.save).to be(true)

    fail1 = Implication.create(atoms: [atoms.first], implies: atoms.second)
    expect(fail1.save).to be(false)

    success2 = Implication.create(atoms: atoms[0..1], implies: atoms[2])
    expect(success2.save).to be(true)

    fail2 = Implication.create(atoms: atoms[0..1], implies: atoms[2])
    expect(fail2.save).to be(false)

    success3 = Implication.create(atoms: [atoms.second], implies: atoms.third)
    expect(success3.save).to be(true)
  end

  it 'tests that stuff_w_props and property are of the same structure' do
    s1 = create(:structure)
    p1 = create(:property, structure: s1)
    s2 = create(:structure)
    p2 = create(:property, structure: s2)

    fail1 = Atom.create(stuff_w_props: s1, property: p2)
    fail2 = Atom.create(stuff_w_props: s2, property: p1)

    expect(fail1.save).to be(false)
    expect(fail2.save).to be(false)

    success1 = Atom.create(stuff_w_props: s1, property: p1)
    success2 = Atom.create(stuff_w_props: s2, property: p2)

    expect(success1.save).to be(true)
    expect(success2.save).to be(true)
  end
end
