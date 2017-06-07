# coding: utf-8
# this has to be loaded after rings_and_modules

ring = Structure.all.to_a.find { |s| s.name_en == 'Ring' }
rmod = Structure.all.to_a.find { |s| s.name_en == '$R$-(left-)module' }
field_property = Property.all.to_a.find { |p| p.name_en == 'field' && p.structure== ring}
base_ring = BuildingBlock.all.to_a.find{ |bb| bb.name_en == 'base ring' }

field = Structure.create do |f|
  f.name_en = 'Field'
  f.name_de = 'Körper'
  f.derives_from = ring
  f.defining_atoms = [field_property.to_atom]
end

vector_space = Structure.create do |v|
  v.name_en = 'Vector space'
  v.name_de = 'Vektorraum'
  v.derives_from = rmod
  v.defining_atoms = [Atom.find_or_create_by(stuff_w_props: base_ring, satisfies: field_property)]
end

fp = {}
[
  ['algebraically closed', 'algebraisch abgeschlossen']
].map do |i|
  fp[i.first] = Property.create do |p|
    p.name_en = i.first
    p.name_de = i.second
    p.structure = field
  end.to_atom
end

rationals = Example.create do |e|
  e.description = '$\mathbb Q$'
  e.structure = field
end

rationals.violates! fp['algebraically closed']

complex = Example.create do |e|
  e.description = '$\mathbb C$'
  e.structure = field
end

complex.satisfies! fp['algebraically closed']
vsp = {}
[
  ['finite dimensional', 'endlich-dimensional']
].map do |i|
  vsp[i.first] = Property.create do |p|
    p.name_en = i.first
    p.name_de = i.second
    p.structure = vector_space
  end.to_atom
end

reals = Example.create do |e|
  e.description_en = '$\mathbb R$ over $\mathbb Q$'
  e.description_de = '$\mathbb R$ über $\mathbb Q$'
  e.structure = vector_space
end

BuildingBlockRealization.create(example: reals, building_block: base_ring, realization: rationals)
reals.violates! vsp['finite dimensional'].property

vsp_endo = Structure.create do |s|
  s.name_en = 'Vector space endomorphism'
  s.name_en = 'Vektorraum-Endomorphismus'
end

underlying_vsp = BuildingBlock.create(explained_structure: vsp_endo, structure: vector_space, name: 'vector space')

endop = {}
[
  ['injective', 'injektiv'],
  ['surjective', 'surjektiv'],
  ['trigonizable', 'trigonalisierbar']
].map do |i|
  endop[i.first] = Property.create do |p|
    p.name_en = i.first
    p.name_de = i.second
    p.structure = vsp_endo
  end.to_atom
end

underlying_vsp_is_fd = Atom.create(stuff_w_props: underlying_vsp, satisfies: vsp['finite dimensional'].property)

[endop['injective'], underlying_vsp_is_fd].is_equivalent! [endop['surjective'], underlying_vsp_is_fd]

underlying_field_is_alg_closed = Atom.create do |a|
  a.stuff_w_props = underlying_vsp
  a.satisfies = Atom.create do |b|
    b.stuff_w_props = base_ring
    b.satisfies = fp['algebraically closed'].property
  end
end

[underlying_vsp_is_fd, underlying_field_is_alg_closed].implies! endop['trigonizable']

polynomials_low_deg = Example.create do |e|
  e.structure = vector_space
  e.description = '$\mathbb C[X]_{\mathrm{deg} \leq 5}$'
end

BuildingBlockRealization.create do |bbr|
  bbr.example = polynomials_low_deg
  bbr.building_block = base_ring
  bbr.realization = complex
end

polynomials_low_deg.satisfies! vsp['finite dimensional']

derivation = Example.create do |e|
  e.structure = vsp_endo
  e.description = '$f\mapsto f\'$'
end

BuildingBlockRealization.create do |bbr|
  bbr.example = derivation
  bbr.building_block = underlying_vsp
  bbr.realization = polynomials_low_deg
end

derivation.violates! endop['injective']
