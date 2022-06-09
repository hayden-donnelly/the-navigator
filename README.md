## About
The Navigator is a first person maze navigation game built with Java and Processing. In order to achieve pseudo-3D visuals, I used a raycast algorithm similar to the one found in Wolfenstein 3D.

This is my ICS4U culminating project.

Gameplay: https://www.youtube.com/watch?v=srRdGsZwh-Q

## Rendering Algorithm

As mentioned, the render algorithm is similar to the one found in Wolfenstien 3D. It uses raycasts to detect walls on a 2D map and then
draws thin vertical rectangles on the screen proportionarl to each ray's length. A constant number of rays are cast for each degree of 
the player's field of view. I chose two rays per degree for aesthetic reasons.

The 2D map is broken up into a grid with walls occupying entire grid cells. Consequently, points of itnersection between rays and walls can
be found by checking if a grid cell contains a wall whenever a ray crosses into it. This process is optimized by finding the vertical grid
line which is adjacent to the player in a ray's direction, calculating the y-component (y<sub>v) of the ray at that line's x-coordinate (x_v), 
checking if a wall occupies the cell that \[x_v, y_v] is pointing to, terminating if it does, and recurring for the next vertical line if it
does not. Betwen each recurrence of this process, a similar process for horizontal gird lines in the ray's direction is run. The main difference being that it calculates the x-component (x_h) of the reay at a horizontal line's y-coordinate (y_h), and then checks the cell that \[x_h, y_h] is pointing to.

## Screenshots
![s2](https://user-images.githubusercontent.com/30982485/107132108-3ce06500-68aa-11eb-9d7c-8b0ca6e87ba5.png)
![s3](https://user-images.githubusercontent.com/30982485/107132109-3ce06500-68aa-11eb-80f8-1aa034ecaee0.png)
![s1](https://user-images.githubusercontent.com/30982485/107132107-3baf3800-68aa-11eb-92a3-658276520121.png)
![s4](https://user-images.githubusercontent.com/30982485/107132110-3d78fb80-68aa-11eb-93da-f5ab3cd49b8a.gif)
