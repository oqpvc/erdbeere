require 'test_helper'

class AtomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "simple implications" do
    assert atoms(:module_is_noeth).follows_from?(atoms(:module_is_fg),
                                                 atoms(:base_ring_is_lnoeth))

    assert_not atoms(:module_is_noeth).follows_from?(atoms(:module_is_fg))
  end
end
