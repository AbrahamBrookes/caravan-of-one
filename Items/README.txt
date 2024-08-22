# Items
Items are bought, sold and transported. An item has a base price, which is then modified depending
on supply and the demand of the purchaser. Items have size and weight, and will almost always be
transported inside a Container.

## Weight
Weight is always in kg and is a float

## Size
Size is always in 10 cubic cm and for the sake of display we'll call these units cubes. When dealing
with cubes just imagine they are stacked on top of each other, we're not cubing cubes.

## Unit of measure
Each item comes in the unit of measure "each". We arbitrarily create a weight and size depending on
what we reckon one each is worth in kg and cubes.
