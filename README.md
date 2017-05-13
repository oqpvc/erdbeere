[![Code Climate](https://codeclimate.com/github/oqpvc/erdbeere/badges/gpa.svg)](https://codeclimate.com/github/oqpvc/erdbeere)
[![Build Status](https://travis-ci.org/oqpvc/erdbeere.svg?branch=master)](https://travis-ci.org/oqpvc/erdbeere)

# erdbeere

ErDBeere is short for “Erkenntnisfördernde Datenbank zur Beispielerfassung und
-entwicklung” (informative database for the development and management of
examples) and should be thought of as an e-learning tool for higher (i. e.,
University level) mathematics.

It aims to store mathematical examples somewhat like
the [ring database](http://ringtheory.herokuapp.com) and is supposed to help
students explore features of mathematical objects. Consider the following
questions:

- What does a principal ideal domain that is not Euclidean look like?
- What does a quasi-projective and proper morphism between schemes look like,
  that isn't projective?
- Is there a ring that is a principal ideal domain, but not a unique
  factorization domain?
  
The first question has a simple enough answer with the ring of integers of
__Q__(√-19). The second also has an example as the answer, but it is worthwhile
to know that every quasi-projective proper morphism X→Y is projective if Y is
qcqs. The third question of course has no example at all, as every principal
ideal domain is a UFD.

ErDBeere wants to represent all the data in the answers above, i.e., *concrete
examples* and *abstract implications*, in the nicest possible manner.

## Installation

Installation is easiest via docker (although `git clone && bundle install`
should also work just fine.) Use the environment variable `SECRET_KEY_BASE`.

The following commands should yield a working installation:

```sh
docker create -e "SECRET_KEY_BASE=production" --name erdbeere -p 3000:3000 oqpvc/erdbeere
docker start erdbeere
```

## Data Structures

The “nicest possible manner” is of course a Web 2.0 application. This is hence a
*Ruby on Rails* project, which isn't all that suitable to represent the
aforementioned data — especially the mathematical implications.

We will explain the internal data structures using example pieces of code.

### Categories, Properties and Implications

```ruby
ring = Structure.create do |s|
  s.name = 'Ring'
  s.definition = 'A ring $R$ is an abelian group together with a ' +
                 'map $R\times R …' 
end

unitary = Property.create do |p|
  p.name = 'unitary'
  p.structure = ring
  p..definition = '…'
end
…
l_noeth = Property.create(name: 'left Noetherian', structure: ring)
r_noeth = Property.create(name: 'right Noetherian', structure: ring)
comm = Property.create(name: 'commutative', structure: ring)
vnr = Property.create(name: 'von Neumann regular (aka absolutely flat)',
                        structure: ring)

```

Rings are easy classes of objects to represent, as they don't depend on other
structures. But as soon as $R$-modules enter the picture, this becomes decidedly
more complicated, as their properties may depend on their ground ring.
Structures can hence have building blocks.

```ruby
rmod = Structure.create(name: '$R$-(left-)Module')
base_ring = BuildingBlock.create(name: 'base ring',
                                   explained_structure: rmod,
                                   structure: ring, definition: 'A ' +
                                   'ring homomorphism $R\longrightarrow ' +
                                   '\mathrm{End}(M)$ …')
```

Now we want to encode the following result: “A finitely generated
$R$-left-module over a left Noetherian ring is itself Noetherian”.

```ruby
fin_gen = Property.create(name: 'finitely generated', structure: rmod)
noeth_module = Property.create(name: 'ascending chain condition for ' +
                               'submodules', structure: rmod)

base_ring_is_lnoeth = Atom.create(stuff_w_props: base_ring, satisfies:
                                   l_noeth)
module_is_fg = Atom.create(stuff_w_props: rmod, satisfies: fin_gen)
module_has_acc = Atom.create(stuff_w_props: rmod, satisfies: noeth_module)

[module_is_fg, base_ring_is_lnoeth].implies! module_has_acc
```

### Examples

An example for a structure in the sense above depends on examples of all of its
building blocks (e. g., for an $R$-module we first need a ring $R$). Consider
the following code snippet:

```ruby
zee = Example.create(structure: ring)
zee.satisfies! [comm, l_noeth, vnr]
zee.violates! vnr

zee_r = Example.create(structure: rmod)
BuildingBlockRealization.create(example: zee_r, building_block:
  base_ring, realization: zee)
zee_r.satisfies! module_is_fg
```

### Using the logic engine

The internal logic engine is as stupid as one get away with. I assume that it is
hence very slow, which still might be fast enough for practical purposes.
Working with it roughly looks like this:

```ruby
[comm, l_noeth].is_equivalent! [comm, r_noeth]

zee_r.satisfies?(module_has_acc)
zee_r.satisfies?(Atom.find_or_create_by(stuff_w_props:
                                                   base_ring,
                                                   satisfies:
                                                   r_noeth))
zee_r.all_that_is_true.each do |a|
  puts a.to_s
end
```

As one can see, the implications on the level of examples work recursively: Even
though we never had an ExampleFact that stated that for commutative *base
rings* (and not *rings*) left and right Noetherian are equivalent, the logic
engine derives those kind of statements from the bottom up.
