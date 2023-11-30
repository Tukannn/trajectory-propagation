# Satellite trajectory propagation

This script shows how to model and visualize a physical system using differential equations and animation in matlab. It can be used as a learning tool or a starting point for higher fidelity models.

It simulates the motion of a satellite on a lunar fly-by trajectory as well as of the Moon around Earth using the gravitational force law.

![](https://github.com/Tukannn/trajectory-propagation/blob/main/live_plot.gif)

The script does the following steps:

- It defines the parameters for the GIF file, such as the name, the delay between frames, and the number of frames to generate.
- It defines the constants related to the gravitational force, such as the gravitational constant, the mass and radius of the Earth and the Moon, and the distance between them.
- It defines the initial conditions for the satellite and the Moon, such as their initial positions and velocities relative to the Earth.
- It defines a system of differential equations that describe the motion of the satellite and the Moon under the influence of the gravitational force from the Earth and each other.
- It solves the system of differential equations using the ode45 function, which is a numerical solver for ordinary differential equations.
- It plots the trajectories of the satellite and the Moon on a figure and adds markers for them.
- It calculates the distance between the satellite and the Moon at each time step and finds the minimum distance and the time of the closest approach.
- It displays the closest approach information on the figure using the text function.
- It updates the plot in real time and writes to the GIF file using the getframe, rgb2ind, and imwrite functions. It only appends every 100th frame of the simulation to the GIF file to reduce the file size.
