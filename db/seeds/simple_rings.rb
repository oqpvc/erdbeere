# coding: utf-8

simring = Structure.create do |r|
  r.name_en = 'Commutative unitary ring '
  r.name_de = 'Kommutativer Ring mit Eins'
end

srp ={}
[
  ['Noetherian', 'noethersch'],
  ['Euclidean domain', 'euklidisch'],
  ['integral domain', 'Integritätbereich'],
  ['UFD', 'faktorieller Ring'],
  %w[PID Hauptidealring],
  %w[field Körper]
].map do |i|
  srp[i.first] = Property.create do |p|
    p.name_en = i.first
    p.name_de = i.second
    p.structure = simring
  end.to_atom
end

srp['field'].implies! srp['Euclidean domain']
srp['Euclidean domain'].implies! srp['PID']
srp['PID'].implies! [srp['UFD'], srp['Noetherian']]
srp['UFD'].implies! srp['integral domain']


simzee = Example.create do |e|
  e.structure = simring
  e.description_en = 'Integers'
  e.description_de = '$\mathbb Z$'
end

simzee.satisfies! srp['Euclidean domain']
simzee.violates! srp['field']

simrationals = Example.create do |e|
  e.structure = simring
  e.description_en = '$\mathbb Q$'
  e.description_de = '$\mathbb Q$'
end

simrationals.satisfies! srp['field']

simreals = Example.create do |e|
  e.structure = simring
  e.description_en = '$\mathbb R$'
  e.description_de = '$\mathbb R$'
end

simreals.satisfies! srp['field']

simcomplex = Example.create do |e|
  e.structure = simring
  e.description_en = '$\mathbb C$'
  e.description_de = '$\mathbb C$'
end

simcomplex.satisfies! srp['field']

simzee_X = Example.create do |e|
  e.structure = simring
  e.description_en = '$\mathbb Z[X]$'
  e.description_de = '$\mathbb Z[X]$'
end

simzee_X.satisfies! [srp['UFD'], srp['Noetherian']]
simzee_X.violates! srp['PID']

simrationals_X = Example.create do |e|
  e.structure = simring
  e.description_en = '$\mathbb Q[X]$'
  e.description_de = '$\mathbb Q[X]$'
end

simrationals_X.satisfies! srp['Euclidean domain']
simrationals_X.violates! srp['field']

simreals_X = Example.create do |e|
  e.structure = simring
  e.description_en = '$\mathbb R[X]$'
  e.description_de = '$\mathbb R[X]$'
end

simreals_X.satisfies! srp['Euclidean domain']
simreals_X.violates! srp['field']

simcomplex_X = Example.create do |e|
  e.structure = simring
  e.description_en = '$\mathbb C[X]$'
  e.description_de = '$\mathbb C[X]$'
end

simcomplex_X.satisfies! srp['Euclidean domain']
simcomplex_X.violates! srp['field']

sim_pid_but_not_euclidean = Example.create do |e|
  e.structure = simring
  e.description = '$\mathbb Z[\frac{1+\sqrt{-19}}{2}]$'
end

sim_pid_but_not_euclidean.satisfies! srp['PID']
sim_pid_but_not_euclidean.violates! srp['Euclidean domain']

sim_domian_but_not_ufd = Example.create do |e|
  e.structure = simring
  e.description = '$\mathbb Z[\sqrt{-5}]$'
end

sim_domian_but_not_ufd.satisfies! [srp['integral domain'], srp ['Noetherian']]
sim_domian_but_not_ufd.violates! srp['UFD']

sim_domain_but_not_ufd_or_notherian = Example.create do |e|
  e.structure = simring
  e.description = '$\mathbb Z[\sqrt{-5},X_1,X_2,\dots]$'
end

sim_domain_but_not_ufd_or_notherian.satisfies! srp['integral domain']
sim_domain_but_not_ufd_or_notherian.violates! [srp['UFD'], srp['Noetherian']]

sim_ufd_but_not_pid_or_noetherian = Example.create do |e|
  e.structure = simring
  e.description = '$\mathbb Z[X_1,X_2,\dots]$'
end

sim_ufd_but_not_pid_or_noetherian.satisfies! srp['UFD']
sim_ufd_but_not_pid_or_noetherian.violates! [srp['PID'], srp['Noetherian']]

sim_Zee_Zee = Example.create do |e|
  e.structure = simring
  e.description = '$\mathbb Z \times \mathbb Z$'
end

sim_Zee_Zee.satisfies! srp['Noetherian']
sim_Zee_Zee.violates! srp['integral domain']

sim_Zee_mod_4 = Example.create do |e|
  e.structure = simring
  e.description = '$\mathbb Z /(4)$'
end

sim_Zee_mod_4.satisfies! srp['Noetherian']
sim_Zee_mod_4.violates! srp['integral domain']

sim_Zee_Zee_infty = Example.create do |e|
  e.structure = simring
  e.description = '$\mathbb Z \times \mathbb Z \times \dots \times \mathbb Z$'
end

sim_Zee_Zee_infty.violates! [srp['integral domain'], srp['Noetherian']]

sim_Zee_mod_4_infty = Example.create do |e|
  e.structure = simring
  e.description = '$\mathbb Z/(4) \times \dots \times \mathbb Z/(4)$'
end

sim_Zee_mod_4_infty.violates! [srp['integral domain'], srp['Noetherian']]



#simple_ring_element = Structure.create do |e|
#  e.name_en = 'Element of a unitary commutativ ring'
#  e.name_de = 'Element eines kommutativen Rings mit Eins'
#end

#ring_of_the_element = BuildingBlock.create do |b|
 # b.name_en = 'in the Ring'
#  b.name_de = 'in dem Ring'
#  b.structure = simring
#  b.explained_structure = simple_ring_element
#end

#srep = {}
#[ 
#  ['unit', 'Einheit'],
#  ['irreducible', 'irreduzibel'],
#  ['prime', 'Primelement']
#].map do |i|
#  srep[i.first] = Property.create do |p|
#    p.name_en = i.first
#    p.name_de = i.second
#    p.structure = simple_ring_element
#  end.to_atom
#end








