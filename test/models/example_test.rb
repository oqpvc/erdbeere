require 'test_helper'

class ExampleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "implications on examples" do
    integers = examples(:integers)
    zee_r = examples(:zee_r)

    module_is_fg = atoms(:module_is_fg)
    module_is_noeth = atoms(:module_is_noeth)
    ring_is_lnoeth = atoms(:ring_is_lnoeth)
    base_ring_is_lnoeth = atoms(:base_ring_is_lnoeth)
    ring_is_comm = atoms(:ring_is_comm)

    # this is hardcoded in example_truths
    assert integers.satisfies?(ring_is_lnoeth)
    assert zee_r.satisfies?(module_is_fg)

    # this is a simple implication
    assert zee_r.satisfies?(module_is_noeth)
    base_ring_is_rnoeth = Atom.find_or_create_by({stuff_w_props:
                                                   building_blocks(:base_ring),
                                                   property: properties(:r_noeth)})

    assert zee_r.satisfies?(base_ring_is_rnoeth)
  end
end
