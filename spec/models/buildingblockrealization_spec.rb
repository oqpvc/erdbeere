require "rails_helper"

RSpec.describe BuildingBlockRealization, type: :model do
  it 'tests if types match' do
    s1 = create(:structure)
    e1 = create(:example, structure: s1)

    s2 = create(:structure)
    e2 = create(:example, structure: s2)

    bb = create(:building_block, structure: s2, explained_structure: s1)

    success = BuildingBlockRealization.create do |bbr|
      bbr.example = e1
      bbr.building_block = bb
      bbr.realization = e2
    end

    expect(success.save).to be(true)

    failure = BuildingBlockRealization.create do |bbr|
      bbr.example = e1
      bbr.building_block = bb
      bbr.realization = e1
    end

    expect(failure.save).to be(false)
  end
end
