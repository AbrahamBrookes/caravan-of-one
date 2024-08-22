# Caravan of one
Loosely, this game is like transport tycoon, but in a medieval setting. You gather goods from one
place, form a caravan and sell it in another place.

# Development

## Computed Getters
Godot allows us to have custom getters and setters on our class properties. They look a bit like this:

	var property_name:Type :
		get:
			return some_other_property + 1
		set:
			pass

As you can see, the getter can do some thinkery dinking before returning a value, and the setter is
simply discarding whatever value you give it. Internally you'll want to reference some other property
on the class to do your computations, and return a subsequent value. When that other property is
updated, the computed getter updates automatically, giving us vue-style reactivity. Nice!

Even better, if you @export the var, you can see the value update in real time in the editor.

Note: in order to keep it simple, computed getters should only ever return some value and should
never have any side effects ie modifying some other value. That would get confusing _real quick_.
If you want to have some value be updated, make that a func that can be called instead.
