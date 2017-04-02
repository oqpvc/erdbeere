require 'test_helper'

class AtomTest < ActiveSupport::TestCase
  test "simple implications" do
    assert atoms(:module_is_noeth).follows_from?(atoms(:module_is_fg),
                                                 atoms(:base_ring_is_lnoeth))

    assert_not atoms(:module_is_noeth).follows_from?(atoms(:module_is_fg))
  end

  test "no duplicate atoms" do
    # this should already be atoms(:module_is_fg)
    a = Atom.new({stuff_w_props: structures(:rmod), property:
                   properties(:fin_gen)})
    assert_not a.save

    # this should already be atoms(:base_ring_is_lnoeth)
    b = Atom.new({stuff_w_props: building_blocks(:base_ring),
                   property: properties(:l_noeth)})
    assert_not b.save

    # this is useless (who cares if the ring is right Noetherian if
    # we're talking about left modules), and hence not in the fixtures
    c = Atom.new({stuff_w_props: building_blocks(:base_ring),
                   property: properties(:r_noeth)})
    assert c.save
  end
end
