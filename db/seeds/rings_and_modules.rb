# coding: utf-8

ring = Structure.create do |r|
  r.name_en = 'Ring'
  r.name_de = 'Ring'
  r.definition_en = 'A ring $R$ is an abelian group together with a ' \
                    'map $R\times R …'
end

rp = {}
[
  ['unitary', 'mit Eins'],
  ['left Noetherian', 'linksnoethersch'],
  ['right Noetherian', 'rechtsnoethersch'],
  %w[commutative kommutativ],
  ['absolutely flat', 'von Neumann regulär'],
  ['Euclidean domain', 'euklidisch'],
  ['UFD', 'faktorieller Ring'],
  ['integral domain', 'Integritätbereich'],
  %w[PID Hauptidealring],
  ['integrally closed domain', 'normal'],
  %w[Dedekind Dedekind],
  %w[field Körper]
].map do |i|
  rp[i.first] = Property.create do |p|
    p.name_en = i.first
    p.name_de = i.second
    p.structure = ring
  end.to_atom
end

[rp['commutative'], rp['left Noetherian']].is_equivalent! [rp['commutative'], rp['right Noetherian']]

rp['field'].implies! rp['Euclidean domain']
rp['Euclidean domain'].implies! rp['PID']
rp['PID'].implies! [rp['UFD'], rp['Dedekind']]
rp['Dedekind'].implies! [rp['integrally closed domain'], rp['left Noetherian']]
rp['UFD'].implies! rp['integrally closed domain']
rp['integrally closed domain'].implies! rp['integral domain']
rp['integral domain'].implies! [rp['commutative'], rp['unitary']]

[rp['Dedekind'], rp['UFD']].implies! rp['PID']

zee = Example.create do |e|
  e.structure = ring
  e.description_en = 'Integers'
  e.description_de = '$\mathbb Z$'
end

zee.satisfies! [rp['Euclidean domain'], rp['left Noetherian']]
zee.violates! [rp['absolutely flat'], rp['field']]

pid_but_not_euclidean = Example.create do |e|
  e.structure = ring
  e.description = '$\mathbb Z[\frac{1+\sqrt{-19}}{2}]$'
end

pid_but_not_euclidean.satisfies! rp['PID']
pid_but_not_euclidean.violates! [rp['Euclidean domain'], rp['absolutely flat']]

ufd_but_not_dedekind = Example.create do |e|
  e.structure = ring
  e.description = '$\mathbb Z[X]$'
end

ufd_but_not_dedekind.satisfies! rp['UFD']
ufd_but_not_dedekind.violates! [rp['Dedekind'], rp['absolutely flat']]

dedekind_but_not_ufd = Example.create do |e|
  e.structure = ring
  e.description = '$\mathbb Z[\sqrt{-5}]$'
end

dedekind_but_not_ufd.satisfies! rp['Dedekind']
dedekind_but_not_ufd.violates! [rp['absolutely flat'], rp['UFD']]

right_not_left_noeth = Example.create do |e|
  e.structure = ring
  e.description = '$\begin{pmatrix}\mathbb Z& \mathbb Q \\\\ 0 & \mathbb Q\end{pmatrix}$'
end

right_not_left_noeth.violates! [rp['commutative'], rp['left Noetherian']]
right_not_left_noeth.satisfies! [rp['right Noetherian'], rp['unitary']]

not_comm_not_unit = Example.create do |e|
  e.structure = ring
  e.description = '$\mathrm{M}_{2\times 2}(2\mathbb Z)$'
end

not_comm_not_unit.violates! [rp['commutative'], rp['unitary'], rp['absolutely flat']]
not_comm_not_unit.satisfies! [rp['left Noetherian'], rp['right Noetherian']]

comm_not_noeth = Example.create do |e|
  e.structure = ring
  e.description = '$\mathbb Z[X_1, X_2, \dots]$'
end

comm_not_noeth.satisfies! [rp['commutative'], rp['unitary']]
comm_not_noeth.violates! [rp['left Noetherian'], rp['absolutely flat']]

rmod = Structure.create do |s|
  s.name_en = '$R$-(left-)module'
  s.name_de = '$R$-(links-)Modul'
end

base_ring = BuildingBlock.create do |b|
  b.name_en = 'base ring'
  b.explained_structure = rmod
  b.structure = ring
  b.definition_en = 'A ring homomorphism $R\longrightarrow ' \
                    '\mathrm{End}(M)$ …'
end

mp = {}
[
  ['finitely generated', 'endlich erzeugt'],
  ['ACC for submodules', 'noethersch']
].map do |i|
  mp[i.first] = Property.create do |p|
    p.name_en = i.first
    p.name_de = i.second
    p.structure = rmod
  end.to_atom
end

base_ring_is_lnoeth = Atom.create(stuff_w_props: base_ring, satisfies:
                                                               rp['left Noetherian'].property)

[base_ring_is_lnoeth, mp['finitely generated']].implies! mp['ACC for submodules']

zee_r = Example.create do |e|
  e.structure = rmod
  e.description_de = '$\mathbb Z^r$ als Modul über $\mathbb Z$'
  e.description_en = '$\mathbb Z^r$ as a module over the integers'
end

BuildingBlockRealization.create(example: zee_r, building_block:
  base_ring, realization: zee)

zee_r.satisfies! mp['finitely generated']

fg_not_noeth_mod = Example.create do |e|
  e.structure = rmod
  e.description_en = '$\mathbb Z[X_1, X_2, \dots]$ as a module over itself'
  e.description_de = '$\mathbb Z[X_1, X_2, \dots]$ als Modul über sich selbst'
end

BuildingBlockRealization.create(example: fg_not_noeth_mod, building_block: base_ring, realization: comm_not_noeth)
fg_not_noeth_mod.satisfies! mp['finitely generated']
fg_not_noeth_mod.violates! mp['ACC for submodules']
