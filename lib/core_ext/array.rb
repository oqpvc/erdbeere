# coding: utf-8
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
    return tmp1
  end

  def all_that_follows_with_implications
    until_stable(:follows_in_one_iteration_with_implications, self)
  end

  def follows_in_one_iteration
    new_atoms = []

    # using .all.to_a is actually correct here! benchmarking shows a factor 4
    # compared to find_each (dafuq?!)
    Premise.where(atom: self).includes(implication: :atoms).all.to_a do |pr|
      if (pr.implication.atoms - self).empty?
        new_atoms.push(pr.implication.implies)
      end
    end

    (self + new_atoms).uniq
  end

  def follows_in_one_iteration_with_implications
    imps_w_atoms = {}
    atoms = []
    if (not self.second.nil?) && self.second.kind_of?(Hash)
      imps_w_atoms = self.second
      atoms = self.first
    else
      atoms = self
    end

    interesting_implications = Implication.all.to_a.find_all do |i|
      (i.atoms - atoms).empty? && (not atoms.include?(i.implies))
    end

    interesting_implications.each do |i|
      imps_w_atoms[i] = i.implies
    end

    # .uniq is actually necessary, as multiple implications might have the same
    # consequence
    return [(atoms + imps_w_atoms.values).uniq, imps_w_atoms]
  end

  def implies!(atom)
    raise 'Not all members of Array are Atoms' unless of_atoms?
    if atom.kind_of?(Array) then
      atom.each do |a|
        self.implies! a
      end
    elsif atom.kind_of?(Atom) then
      Implication.create({atoms: self, implies: atom})
    else
      raise 'Argument not of type Atom'
    end
  end

  def is_equivalent!(atoms)
    atoms.each do |a|
      Implication.create({atoms: self, implies: a})
    end
    self.each do |a|
      Implication.create({atoms: atoms, implies: a})
    end
  end
end
