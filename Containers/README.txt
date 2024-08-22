# Containers
Containers are objects that store items. Items are measured in size and weight. Containers can generally
hold a fixed size and the weight of all items gives the weight of the container. Containers are themselves
an item and so they have a size and weight, and can be sold and transported like any other item.

We have two main ways we achieve this - the Container resource template and the Containers scene. In
order to create a new type of container, use the ItemContainer resource template (have a look at the
comment at the top of the file for how to do that). In order to allow a scene to have containers,
give it a Containers node as a sub-scene, and assign ItemContainers to its containers list. You can
then use the helper functions of that subscene to interact with the containers.
