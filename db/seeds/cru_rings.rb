# coding: utf-8

cruring = Structure.create do |r|
  r.name_en = 'Commutative unitary ring '
  r.name_de = 'Kommutativer Ring mit Eins'
end

crurp ={}
[
  ['Noetherian', 'noethersch', '00FM'],
  ['Euclidean domain', 'euklidisch'],
  ['integral domain', 'Integritätbereich'],
  ['UFD', 'faktorieller Ring'],
  ['PID', 'Hauptidealring'],
  ['field', 'Körper'],
  ['finite', 'endlich']
].map do |i|
  crurp[i.first] = Property.create do |p|
    p.name_en = i.first
    p.name_de = i.second
    p.stackstag = i.third
    p.structure = cruring
  end.to_atom
end

crurp['field'].implies! crurp['Euclidean domain']
crurp['Euclidean domain'].implies! crurp['PID']
crurp['PID'].implies! [crurp['UFD'], crurp['Noetherian']]
crurp['UFD'].implies! crurp['integral domain']
crurp['finite'].implies! crurp['Noetherian']
[crurp['finite'], crurp['integral domain']].implies! crurp['field']


cruzee = Example.create do |e|
  e.structure = cruring
  e.description_en = 'Integers'
  e.description_de = '$\mathbb Z$'
end
cruzee.satisfies! crurp['Euclidean domain']
cruzee.violates! [crurp['finite'], crurp['finite']]


crurationals = Example.create do |e|
  e.structure = cruring
  e.description_en = '$\mathbb Q$'
  e.description_de = '$\mathbb Q$'
end
crurationals.satisfies! crurp['field']
crurationals.violates! crurp['finite']


crureals = Example.create do |e|
  e.structure = cruring
  e.description_en = '$\mathbb R$'
  e.description_de = '$\mathbb R$'
end
crureals.satisfies! crurp['field']
crureals.violates! crurp['finite']


crucomplex = Example.create do |e|
  e.structure = cruring
  e.description_en = '$\mathbb C$'
  e.description_de = '$\mathbb C$'
end
crucomplex.satisfies! crurp['field']
crucomplex.violates! crurp['finite']


cruzee_X = Example.create do |e|
  e.structure = cruring
  e.description_en = '$\mathbb Z[X]$'
  e.description_de = '$\mathbb Z[X]$'
end
cruzee_X.satisfies! [crurp['UFD'], crurp['Noetherian']]
cruzee_X.violates! [crurp['PID'], crurp['finite']]


crurationals_X = Example.create do |e|
  e.structure = cruring
  e.description_en = '$\mathbb Q[X]$'
  e.description_de = '$\mathbb Q[X]$'
end
crurationals_X.satisfies! crurp['Euclidean domain']
crurationals_X.violates! [crurp['field'], crurp['finite']]


crureals_X = Example.create do |e|
  e.structure = cruring
  e.description_en = '$\mathbb R[X]$'
  e.description_de = '$\mathbb R[X]$'
end
crureals_X.satisfies! crurp['Euclidean domain']
crureals_X.violates! [crurp['field'], crurp['finite']]


crucomplex_X = Example.create do |e|
  e.structure = cruring
  e.description_en = '$\mathbb C[X]$'
  e.description_de = '$\mathbb C[X]$'
end
crucomplex_X.satisfies! crurp['Euclidean domain']
crucomplex_X.violates! [crurp['field'], crurp['finite']]


cru_pid_but_not_euclidean = Example.create do |e|
  e.structure = cruring
  e.description = '$\mathbb Z[\frac{1+\sqrt{-19}}{2}]$'
end
cru_pid_but_not_euclidean.satisfies! crurp['PID']
cru_pid_but_not_euclidean.violates! [crurp['Euclidean domain'], crurp['finite']]


cru_domian_but_not_ufd = Example.create do |e|
  e.structure = cruring
  e.description = '$\mathbb Z[\sqrt{-5}]$'
end
cru_domian_but_not_ufd.satisfies! [crurp['integral domain'], crurp ['Noetherian']]
cru_domian_but_not_ufd.violates! [crurp['UFD'], crurp['finite']]


cru_domain_but_not_ufd_or_notherian = Example.create do |e|
  e.structure = cruring
  e.description = '$\mathbb Z[\sqrt{-5},X_1,X_2,\dots]$'
end
cru_domain_but_not_ufd_or_notherian.satisfies! crurp['integral domain']
cru_domain_but_not_ufd_or_notherian.violates! [crurp['UFD'], crurp['Noetherian'], crurp['finite']]


cru_ufd_but_not_pid_or_noetherian = Example.create do |e|
  e.structure = cruring
  e.description = '$\mathbb Z[X_1,X_2,\dots]$'
end
cru_ufd_but_not_pid_or_noetherian.satisfies! crurp['UFD']
cru_ufd_but_not_pid_or_noetherian.violates! [crurp['PID'], crurp['Noetherian'], crurp['finite']]


cru_Zee_Zee = Example.create do |e|
  e.structure = cruring
  e.description = '$\mathbb Z \times \mathbb Z$'
end
cru_Zee_Zee.satisfies! crurp['Noetherian']
cru_Zee_Zee.violates! [crurp['integral domain'], crurp['finite']]


cru_Zee_mod_4 = Example.create do |e|
  e.structure = cruring
  e.description = '$\mathbb Z /(4)$'
end
cru_Zee_mod_4.satisfies! [crurp['Noetherian'], crurp['finite']]
cru_Zee_mod_4.violates! crurp['integral domain']


cru_Zee_Zee_infty = Example.create do |e|
  e.structure = cruring
  e.description = '$\mathbb Z \times \mathbb Z \times \dots \times \mathbb Z \times \dots$'
end
cru_Zee_Zee_infty.violates! [crurp['integral domain'], crurp['Noetherian'], crurp['finite']]


cru_Zee_mod_4_infty = Example.create do |e|
  e.structure = cruring
  e.description = '$\mathbb Z/(4) \times \dots \times \mathbb Z/(4) \times \dots$'
end
cru_Zee_mod_4_infty.violates! [crurp['integral domain'], crurp['Noetherian'], crurp['finite']]


cru_Zee_mod_5 = Example.create do |e|
  e.structure = cruring
  e.description = '$\mathbb Z/(5)$'
end
cru_Zee_mod_5.satisfies! [crurp['finite'], crurp['field']]



#cru_ring_element = Structure.create do |e|
#  e.name_en = 'Element of a unitary commutativ ring'
#  e.name_de = 'Element eines kommutativen Rings mit Eins'
#end

#ring_of_the_element = BuildingBlock.create do |b|
 # b.name_en = 'in the Ring'
#  b.name_de = 'in dem Ring'
#  b.structure = cruring
#  b.explained_structure = cru_ring_element
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
#    p.structure = cru_ring_element
#  end.to_atom
#end








