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

        // Change in y from player's position to first horizontal interception
        float initial_horint_delta_y =  (ray_y > 0) ? p.y_pos - Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size : 
                                        (ray_y < 0) ? p.y_pos - Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size - lev1.cell_size : 0;
        // Change in x from player's position to first vertical interception
        float initial_verint_delta_x =  (ray_x > 0) ? Math.floor(p.x_pos / lev1.cell_size) * lev1.cell_size + lev1.cell_size - p.x_pos :
                                        (ray_x < 0) ? Math.floor(p.x_pos / lev1.cell_size) * lev1.cell_size - p.x_pos : 0;

        int horizontal_iteration = 1;
        int vertical_iteration = 1;
        while(true)
        {
            float horint_delta_y = initial_horint_delta_y + lev1.cell_size * horizontal_iteration;
            float horint_delta_x = horint_delta_y / rotation_tangent;
            int horint_id = lev1.map[Math.floor((p.y_pos - horint_delta_y) / lev1.cell_size * lev1.map_width) 
                                        + Math.floor((p.x_pos + horint_delta_x) / lev1.cell_size)];

            float verint_delta_x = initial_verint_delta_x + lev1.cell_size * vertical_iteration;
            float verint_delta_y = verint_delta_x * rotation_tangent;
            int verint_id = lev1.map[Math.floor((p.y_pos - verint_delta_y) / lev1.cell_size * lev1.map_width)
                                        + Math.floor((p.x_pos + verint_delta_x) / lev1.cell_size)];

            if(horint_id == 0 && verint_id == 0)
            {
                continue;
            }

            float horint_length = Math.sqrt(Math.pow(horint_delta_y, 2) + Math.pow(horint_delta_x, 2));
            float verint_length = Math.sqrt(Math.pow(verint_delta_y, 2) + Math.pow(verint_delta_x, 2));

            if(horint_id != 0)
            {
                if(horint_length <= verint_length)
                {
                    // Calculate column height
                    break;
                }
                vertical_iteration++;
            }
            if(verint_id != 0)
            {
                if(verint_length <= horint_length)
                {
                    // Calculate column height
                    break;
                }
                horizontal_iteration++;
            }
        }
    }
}