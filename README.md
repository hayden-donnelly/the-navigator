## About
The Navigator is my ICS4U culminating project; a first person maze navigation game built with Java and Processing. You must navigate a procedurally generated maze and 
reach the exit as quickly as you can. I used a raycast rendering algorithm similar to the one found in Wolfenstein 3D to achieve pseudo-3D visuals.

Gameplay: https://www.youtube.com/watch?v=srRdGsZwh-Q

## Rendering Algorithm

As mentioned, the render algorithm is similar to the one found in Wolfenstien 3D. It uses raycasts to detect walls on a 2D map and then
draws thin vertical rectangles on the screen proportional to each ray's length. A constant number of rays are cast for each degree of 
the player's field of view. I chose two rays per degree (or one ray per 0.5 degrees) for aesthetic reasons.

The 2D map is broken up into a grid with walls occupying entire grid cells. Consequently, points of intersection between rays and walls can
be found by checking if a grid cell contains a wall whenever a ray crosses into it. This process is optimized by finding the vertical grid
line which is adjacent to the player in a ray's direction, calculating the y-component (*y<sub>v</sub>*) of the ray at that line's x-coordinate (*x<sub>v</sub>*), 
checking if a wall occupies the cell that \[*x<sub>v</sub> y<sub>v</sub>*] is pointing to (relative to the player's position), terminating if it does, and recurring for the next vertical line if it
does not. 

![IMG_0772](https://user-images.githubusercontent.com/30982485/172924810-16fe8d09-7311-4994-9c1c-a5e9ce63b2f4.jpg)

Betwen each recurrence of this process, a similar process for horizontal grid lines in the ray's direction is run. The main difference 
being that it calculates the x-component (*x<sub>h</sub>*) of the ray at a horizontal line's y-coordinate (*y<sub>h</sub>*), and then checks 
the cell that \[*x<sub>h</sub> y<sub>h</sub>*] is pointing to (again, relative to the player's position). These two processes will each return 
a different vector. Whichever one is shorter will be used to calculate the distance to the wall from the player at the given angle.

![IMG_0773](https://user-images.githubusercontent.com/30982485/172924807-9c8078c3-bbe7-4d76-b93a-cbd8f26814f7.jpg)

After an intersection vector has been determined, it is projected onto the direction the player is looking. Then the height of the correpsonding
rectangle is calculated as a function the resulting vector's magnitude. This prevents the final render from developing
a fisheye effect.

## Screenshots
![s2](https://user-images.githubusercontent.com/30982485/107132108-3ce06500-68aa-11eb-9d7c-8b0ca6e87ba5.png)
![s3](https://user-images.githubusercontent.com/30982485/107132109-3ce06500-68aa-11eb-80f8-1aa034ecaee0.png)
![s1](https://user-images.githubusercontent.com/30982485/107132107-3baf3800-68aa-11eb-92a3-658276520121.png)
![s4](https://user-images.githubusercontent.com/30982485/107132110-3d78fb80-68aa-11eb-93da-f5ab3cd49b8a.gif)
