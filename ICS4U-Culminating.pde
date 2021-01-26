import java.util.*; 

class Level
{
    int map[];
    int map_width, map_height, cell_size;
}
Level lev1;

class Player
{
    int x_pos, y_pos, fov;
    float rotation;
}
Player p;

void setup()
{
    lev1 = new Level();
    lev1.map = {    1, 1, 1, 1, 1, 1, 1, 1,
                    1, 0, 0, 1, 0, 1, 1, 1,
                    1, 0, 0, 1, 0, 1, 1, 1,
                    1, 0, 0, 0, 0, 0, 0, 1,
                    1, 0, 0, 0, 0, 0, 0, 1,
                    1, 0, 0, 0, 0, 0, 0, 1,
                    1, 1, 1, 1, 1, 1, 1, 1, };
    lev1.map_width = 9;
    lev1.map_height = 7;
    lev1.cell_size = 20;

    p = new Player();
    p.x_pos = 100;
    p.y_pos = 80;
    p.rotation = 45;
    p.fov = 90;
}

void draw()
{
    for(int i = -p.fov/2; i <= p.fov/2; i++)
    {
        float ray_rotation = p.rotation + i;
        float rotation_tangent = Math.tan(Math.toRadians(ray_rotation));
        float ray_y = Math.sin(Math.toRadians(ray_rotation));
        float ray_x = Math.cos(Math.toRadians(ray_rotation));

        float initial_delta_y = (ray_y > 0) ? p.y_pos - Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size : 
                                (ray_y < 0) ? p.y_pos - Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size - lev1.cell_size : 0;
        float initial_delta_x = (ray_x > 0) ? Math.floor(p.x_pos / lev1.cell_size) * lev1.cell_size + lev1.cell_size - p.x_pos :
                                (ray_x < 0) ? Math.floor(p.x_pos / lev1.cell_size) * lev1.cell_size - p.x_pos : 0;

        int horizontal_iteration = 1;
        int vertical_iteration = 1;
        while(true)
        {
            float delta_y = initial_delta_y + cell_size * horizontal_iteration;
            float x = delta_y / rotation_tangent;
            float horizontal_interception_length = Math.sqrt(delta_y*delta_y + x*x)

            float delta_x = initial_delta_x + cell_size * vertical_iteration;
            float y = delta_x * rotation_tangent;
            float vertical_interception_length = Math.sqrt(delta_x*delta_x + y*y);
        }
    }
}