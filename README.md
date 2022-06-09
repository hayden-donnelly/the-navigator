## About
The Navigator is a first person maze navigation game built with Java and Processing. In order to achieve pseudo-3D visuals, I used a raycast algorithm similar to the one found in Wolfenstein 3D.

This is my ICS4U culminating project.

Gameplay: https://www.youtube.com/watch?v=srRdGsZwh-Q

## Rendering Algorithm

As mentioned, the render algorithm is similar to the one found in Wolfenstien 3D. It uses raycasts to detect walls on a 2D map and then
draws thin vertical rectangles on the screen proportionarl to each ray's length. A constant number of rays are cast for each degree of the player's field of view. I chose two rays per degree for aesthetic reasons.

## Screenshots
![s2](https://user-images.githubusercontent.com/30982485/107132108-3ce06500-68aa-11eb-9d7c-8b0ca6e87ba5.png)
![s3](https://user-images.githubusercontent.com/30982485/107132109-3ce06500-68aa-11eb-80f8-1aa034ecaee0.png)
![s1](https://user-images.githubusercontent.com/30982485/107132107-3baf3800-68aa-11eb-92a3-658276520121.png)
![s4](https://user-images.githubusercontent.com/30982485/107132110-3d78fb80-68aa-11eb-93da-f5ab3cd49b8a.gif)
