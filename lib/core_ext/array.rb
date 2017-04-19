# coding: utf-8

# if not called with an upper limit, this runs forever!
def until_stable(function, seed, iterations = -1)
  return seed if iterations.zero?

  tmp = seed

  seed = seed.send(function)

  if tmp == seed
    seed
  else
    until_stable(function, seed, iterations - 1)
  end
end

class Array
  def of_atoms?
    find_all { |m| !m.is_a?(Atom) }.empty?
  end

  def all_that_follows
    raise 'Not all members of Array are Atoms' unless of_atoms?

    until_stable(:follows_in_one_iteration, self)
  end

  def all_that_follows_with_implications
    until_stable(:follows_in_one_iteration_with_implications, self)
  end

  def interesting_premises(atoms: self)
    Premise.where(atom: atoms).includes(implication: :atoms).where.not(implications: {implies: atoms})
  end

  def follows_in_one_iteration
    (interesting_premises.to_a.find_all do |pr|
      (pr.implication.atoms - self).empty?
    end.map { |pr| pr.implication.implies } + self).uniq
  end

  def follows_in_one_iteration_with_implications
    imps_w_atoms = {}
    atoms = []

    if (!second.nil?) && second.is_a?(Hash)
      imps_w_atoms = second
      atoms = first
    else
      atoms = self
    end

    interesting_implications = []

    interesting_premises(atoms: atoms).to_a.each do |pr|
      if (pr.implication.atoms - atoms).empty?
        interesting_implications.push(pr.implication)
      end
    end

    interesting_implications.each do |i|
      imps_w_atoms[i] = i.implies
    end

    # .uniq is actually necessary, as multiple implications might have the same
    # consequence
    [(atoms + imps_w_atoms.values).uniq, imps_w_atoms]
  end

  def implies!(atom)
    raise 'Not all members of Array are Atoms' unless of_atoms?
    if atom.is_a?(Array)
      atom.each do |a|
        implies! a
      end
    elsif atom.is_a?(Atom)
      Implication.create(atoms: self, implies: atom)
    else
      raise 'Argument not of type Atom'
    end
  end

  def is_equivalent!(atoms)
    atoms.each do |a|
      Implication.create(atoms: self, implies: a)
    end
    each do |a|
      Implication.create(atoms: atoms, implies: a)
    end
  end
end
