# coding: utf-8

scheme = Structure.create do |s|
  s.name_en = 'Scheme'
  s.name_de = 'Schema'
end

sp = {}
[
  %w[Noetherian noethersch],
  %w[qcqs qcqs]
].map do |i|
  sp[i.first] = Property.create do |p|
    p.name_en = i.first
    p.name_de = i.second
    p.structure = scheme
  end.to_atom
end

s_mor = Structure.create do |s|
  s.name_en = 'Scheme morphism'
  s.name_de = 'Schema-Morphismus'
end

domain = BuildingBlock.create do |b|
  b.structure = scheme
  b.explained_structure = s_mor
  b.name_en = 'Domain'
  b.name_de = 'Quelle'
end

codomain = BuildingBlock.create do |b|
  b.structure = scheme
  b.explained_structure = s_mor
  b.name_en = 'Codomain'
  b.name_de = 'Ziel'
end

mp = {}
[
  %w[affine affin],
  ['closed immersion', 'abgeschlossene Immersion'],
  %w[étale étale],
  ['faithfully flat', 'treuflach'],
  ['finite type', 'von endlichem Typ'],
  %w[finite endlich],
  ['finitely presented', 'endlich präsentiert'],
  %w[flat flach],
  %w[immersion Immersion],
  # what's the right translation for integral?
  ['integral', 'affin und universell abgeschlossen'],
  %w[isomorphism Isomorphismus],
  ['locally of finite presentation', 'lokal endlich präsentiert'],
  %w[monomorphism Monomorphismus],
  ['open immersion', 'offene Immersion'],
  %w[projective projektiv],
  %w[proper eigentlich],
  ['purely inseparable', 'rein inseparabel'],
  %w[qcqs qcqs],
  ['quasi-affine', 'quasi-affin'],
  ['quasi-compact', 'quasikompakt'],
  ['quasi-finite', 'quasi-endlich'],
  ['quasi-projective', 'quasiprojektiv'],
  ['quasi-separated', 'quasisepariert'],
  %w[separated separiert],
  %w[smooth glatt],
  %w[surjective surjektiv],
  ['universal homeomorphism', 'universeller Homöomorphismus'],
  ['universally closed', 'universell abgeschlossen'],
  ['universally open', 'universell offen']
].map do |i|
  mp[i.first] = Property.create do |p|
    p.name_en = i.first
    p.name_de = i.second
    p.structure = s_mor
  end.to_atom
end

[mp['universal homeomorphism'], mp['finite type']].is_equivalent! [mp['purely inseparable'], mp['finite'], mp['surjective']]
mp['closed immersion'].is_equivalent! [mp['proper'], mp['monomorphism']]
mp['finite'].is_equivalent! [mp['quasi-affine'], mp['proper']]
mp['integral'].is_equivalent! [mp['affine'], mp['universally closed']]
mp['qcqs'].is_equivalent! [mp['quasi-compact'], mp['quasi-separated']]

mp['isomorphism'].implies! [
  mp['closed immersion'],
  mp['universal homeomorphism'],
  mp['open immersion'],
  mp['faithfully flat']
]

mp['closed immersion'].implies! [mp['finite'], mp['immersion'], mp['quasi-compact']]
mp['immersion'].implies! mp['monomorphism']
mp['monomorphism'].implies! mp['purely inseparable']
mp['purely inseparable'].implies! mp['separated']
mp['separated'].implies! mp['quasi-separated']

mp['faithfully flat'].implies! [mp['surjective'], mp['flat']]
mp['open immersion'].implies! [mp['étale'], mp['immersion']]
mp['étale'].implies! mp['smooth']

mp['smooth'].implies! [mp['flat'], mp['locally of finite presentation']]
[mp['flat'], mp['locally of finite presentation']].implies! mp['universally open']

mp['universal homeomorphism'].implies! [mp['integral'], mp['universally open'], mp['purely inseparable']]

[mp['quasi-compact'], mp['immersion']].implies! [mp['finite'], mp['separated']]
mp['affine'].implies! mp['quasi-affine']
mp['quasi-affine'].implies! [mp['separated'], mp['quasi-compact']]

mp['finite'].implies! [mp['projective'], mp['quasi-finite'], mp['integral']]
[mp['quasi-finite'], mp['separated']].implies! mp['finite type']
[mp['quasi-affine'], mp['finite type']].implies! mp['quasi-projective']

mp['projective'].implies! [mp['proper'], mp['quasi-projective']]

mp['quasi-projective'].implies! mp['finite type']
mp['finite type'].implies! mp['quasi-compact']
mp['finitely presented'].implies! [mp['finite type'], mp['qcqs']]
mp['proper'].implies! [mp['finite type'], mp['universally closed'], mp['separated']]

domain_is_noeth = Atom.create(stuff_w_props: domain, property: sp['Noetherian'].property)
codomain_is_qcqs = Atom.create(stuff_w_props: codomain, property: sp['qcqs'].property)

[domain_is_noeth, mp['open immersion']].implies! [mp['quasi-compact'], mp['immersion']]
[codomain_is_qcqs, mp['proper'], mp['quasi-projective']].implies! mp['projective']
