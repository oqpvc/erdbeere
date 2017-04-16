# if not called with an upper limit, this runs forever!
def until_stable(function, seed, iterations = -1)
  if iterations == 0
    return seed
  end

  tmp = seed
  seed = seed.send(function)
  if tmp == seed
    seed
  else
    until_stable(function, seed, iterations-1)
  end
end

class Array
  def of_atoms?
    self.find_all { |m| not m.kind_of?(Atom) }.empty?
  end
  def all_that_follows
    raise 'Not all members of Array are Atoms' unless of_atoms?

    until_stable(:follows_in_one_iteration, self)
  end

  def follows_in_one_iteration
    # TODO this is probably the slowest implementation possible. is there a more
    # efficient way that still looks like rails?
    one_iteration = Implication.all.to_a.find_all do |i|
      (i.atoms - self).empty?
    end.map do |i|
      i.implies
    end

    (self + one_iteration).uniq
  end

  def follows_in_one_iteration_with_implications
    interesting_implications = Implication.all.to_a.find_all do |i|
      (i.atoms - self).empty? && (not self.include?(i.implies))
    end

    new_atoms = interesting_implications.map { |i| i.implies }

    # .uniq is actually necessary, as multiple implications might have the same
    # consequence
    return [(self + new_atoms).uniq, interesting_implications]
  end

  def implies!(atom)
    raise 'Not all members of Array are Atoms' unless of_atoms?
    Implication.create({atoms: self, implies: atom})
  end
end
