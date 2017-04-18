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

    tmp1 = []
    tmp2 = self

    until tmp1 == tmp2
      tmp1 = tmp2.dup
      potentially_satisfied = Premise.where(atom: tmp2).includes(implication: :atoms).all.to_a
      potentially_satisfied.each do |pr|
        if (pr.implication.atoms - tmp2).empty?
          tmp2.push(pr.implication.implies)
        end
      end
      tmp2.uniq!
    end
    tmp1
    #until_stable(:follows_in_one_iteration, self)
  end

  def all_that_follows_with_implications
    until_stable(:follows_in_one_iteration_with_implications, self)
  end

  def follows_in_one_iteration_with_implications
    imps_w_atoms = {}
    atoms = []

    if !second.nil? && second.is_a?(Hash)
      imps_w_atoms = second
      atoms = first
    else
      atoms = self
    end

    interesting_implications = []

    Premise.where(atom: self).includes(implication: :atoms).all.to_a do |pr|
      if (pr.implication.atoms - self).empty? && !atoms.include?(pr.implication.implies)
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
