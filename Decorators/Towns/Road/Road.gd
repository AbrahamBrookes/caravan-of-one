extends Decorator
class_name Road

# A Road is the base class for all road types. We have different classes of Roads - dirt roads, goat tracks
# Cobbled Streets, Highways etc. Each type has variants for straights, curves and intersections. We use a
# naming convention to determine the variant where we have the entries of the road demarcated by underscores
# so S_E is a tile that bends from the north to the east, S_W is a tile that bends from the north to the west
# S_N_W is a T intersection where you south-north, or turn west. Then we slap on the road type at the start
# so a cobbled street intersection east west north would be called "CobbledStreet_N_S_E". When naming the
# directions, use the order N E S W ie N_E_S instead of E_S_N or S_N_E. Her ar all the possible directions:
# stubs: N, E, S, W
# straights: N_S, E_W
# curves: N_E, E_S, S_W, W_N
# intersections: N_E_S, E_S_W, S_W_N, W_N_E
# crossroads: N_E_S_W
# for a total of 15 possible variants for each road type

