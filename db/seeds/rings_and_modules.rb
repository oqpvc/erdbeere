# coding: utf-8

ring = Structure.create do |r|
  r.name_en = 'Ring'
  r.name_de = 'Ring'
  r.definition_en = 'A ring $R$ is an abelian group together with a ' +
                    'map $R\times R …'
end

unitary = Property.create({name_en: 'unitary', structure: ring})

l_noeth = Property.create do |p|
  p.name_en = 'left Noetherian'
  p.name_de = 'linksnoethersch'
  p.structure = ring
end

r_noeth = Property.create do |p|
  p.name_en = 'right Noetherian'
  p.name_de = 'rechtsnoethersch'
  p.structure = ring
end

comm = Property.create do |p|
  p.name_en = 'commutative'
  p.structure = ring
end

vnr = Property.create do |p|
  p.name_en = 'von Neumann regular (aka absolutely flat)'
  p.name_de = 'von Neumann regulär'
  p.structure = ring
end

rmod = Structure.create do |s|
  s.name_en = '$R$-(left-)Module'
  s.name_de = '$R$-(links-)Modul'
end

base_ring = BuildingBlock.create do |b|
  b.name_en = 'base ring'
  b.explained_structure = rmod
  b.structure = ring

  b.definition_en = 'A ring homomorphism $R\longrightarrow ' +
                     '\mathrm{End}(M)$ …'

end

Implication.create do |i|
  i.atoms = [comm.to_atom, l_noeth.to_atom]
  i.implies = r_noeth.to_atom
end

Implication.create do |i|
  i.atoms = [comm.to_atom, r_noeth.to_atom]
  i.implies = l_noeth.to_atom
end

fin_gen = Property.create({name_en: 'finitely generated', structure: rmod})
noeth_module = Property.create({name_en: 'ascending chain condition for ' +
                               'submodules', structure: rmod})

base_ring_is_lnoeth = Atom.create({stuff_w_props: base_ring, property:
                                   l_noeth})
module_is_fg = Atom.create({stuff_w_props: rmod, property: fin_gen})
module_has_acc = Atom.create({stuff_w_props: rmod, property: noeth_module})

Implication.create do |i|
  i.atoms = [module_is_fg, base_ring_is_lnoeth]
  i.implies = module_has_acc
end

integers = Example.create do |e|
  e.structure = ring
  e.explanation_en = 'Integers'
  e.explanation_de = '$\mathbb Z$'
end

ExampleTruth.create({example: integers, property: comm, satisfied: true})
ExampleTruth.create({example: integers, property: l_noeth, satisfied: true})
ExampleTruth.create({example: integers, property: unitary, satisfied: true})
ExampleTruth.create({example: integers, property: vnr, satisfied: false})

zee_r = Example.create do |e|
  e.structure = rmod
  e.explanation_de = '$\mathbb Z^r$ als Modul über $\mathbb Z$'
  e.explanation_en = '$\mathbb Z^r$ as a module over the integers'
end

BuildingBlockRealization.create({example: zee_r, building_block:
  base_ring, realization: integers})
ExampleTruth.create({example: zee_r, property: fin_gen, satisfied: true})
