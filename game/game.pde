import java.util.*; 

class Level
{
    int[] map;
    int map_width, map_height, cell_size;
}
Level lev1;

class Player
{
    int x_pos, y_pos, fov;
    float rotation;
}
Player p;

float scaling_factor;

void setup()
{
    size(1280, 720);

    lev1 = new Level();
    int[] placeholder = {   1, 1, 1, 1, 1, 1, 1, 1,
                            1, 0, 0, 1, 0, 1, 1, 1,
                            1, 0, 0, 1, 0, 1, 1, 1,
                            1, 0, 0, 0, 0, 0, 0, 1,
                            1, 0, 0, 0, 0, 0, 0, 1,
                            1, 0, 0, 0, 0, 0, 0, 1,
                            1, 1, 1, 1, 1, 1, 1, 1 };
    lev1.map = placeholder;
    lev1.map_width = 8;
    lev1.map_height = 7;
    lev1.cell_size = 20;

    p = new Player();
    p.x_pos = 100;
    p.y_pos = 90;
    p.rotation = 45;
    p.fov = 90;

    // play around with this
    scaling_factor = 0.5;
/*}

void draw()
{*/
    // Iterate over every angle in player's FOV
    for(int i = -p.fov/2; i <= p.fov/2; i++)
    {
        float absolute_ray_angle = p.rotation + i;
        absolute_ray_angle = (absolute_ray_angle < 0) ? 360 + absolute_ray_angle : absolute_ray_angle;
        float ray_y_sign = Math.signum(Math.sin(Math.toRadians(absolute_ray_angle)));
        float ray_x_sign = Math.signum(Math.cos(Math.toRadians(absolute_ray_angle)));
        float horint_angle = 0;
        float verint_angle = 0;
        float horint_angle_tangent = 0;
        float verint_angle_tangent = 0;
        // Change in y from player's position to first horizontal interception
        float initial_horint_delta_y;
        // Change in x from player's position to first vertical interception
        float initial_verint_delta_x;

        if(ray_x_sign > 0)
        {
            // Quadrants 1 or 4
            if(ray_y_sign > 0)
            {
                // Quadrant 1
                horint_angle = 90 - absolute_ray_angle;
                verint_angle = absolute_ray_angle;

                // Upper delta
                initial_horint_delta_y = Math.abs(Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size - p.y_pos);
            }
            else if(ray_y_sign < 0)
            {
                // Quadrant 4
                horint_angle = absolute_ray_angle - 270;
                verint_angle = 360 - absolute_ray_angle;

                // Lower delta 
                initial_horint_delta_y = Math.abs((Math.floor(p.y_pos / lev1.cell_size) + 1) * lev1.cell_size - p.y_pos)
            }

            // Right delta 
            initial_verint_delta_x = Math.abs((Math.floor(p.x_pos / lev1.cell_size) + 1) * lev1.cell_size - p.x_pos);
        }
        else if(ray_x_sign < 0)
        {
            // Quadrants 2 or 3
            if(ray_y_sign > 0)
            {
                // Quadrant 2
                horint_angle = absolute_ray_angle - 90;
                verint_angle = 180 - absolute_ray_angle;

                // Upper delta
                initial_horint_delta_y = Math.abs(Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size - p.y_pos);
            }
            else if(ray_y_sign < 0)
            {
                // Quadrant 3
                horint_angle = 270 - absolute_ray_angle;
                verint_angle = absolute_ray_angle - 180;

                // Lower delta
                initial_horint_delta_y = Math.abs((Math.floor(p.y_pos / lev1.cell_size) + 1) * lev1.cell_size - p.y_pos)
            }

            // Left delta
            initial_verint_delta_x = Math.abs(Math.floor(p.x_pos / lev1.cell_size) * lev1.cell_size - p.x_pos);
        }
        else
        {
            // Ray is vertical
            if(ray_y_sign > 0)
            {
                // Upper delta
                initial_horint_delta_y = Math.abs(Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size - p.y_pos);
            }
            else if(ray_y_sign < 0)
            {
                // Lower delta
                initial_horint_delta_y = Math.abs((Math.floor(p.y_pos / lev1.cell_size) + 1) * lev1.cell_size - p.y_pos)
            }
        }

        horint_angle_tangent = Math.tan(Math.toRadians(horint_angle));
        verint_angle_tangent = Math.tan(Math.toRadians(verint_angle));

        // Find ray/grid interception points
        int horizontal_iteration = 0;
        int vertical_iteration = 0;
        while(true)
        {
            float horint_delta_y = initial_horint_delta_y + lev1.cell_size * horizontal_iteration;
            float horint_delta_x = horint_delta_y * horint_angle_tangent;

            float verint_delta_x = initial_verint_delta_x + lev1.cell_size * vertical_iteration;
            float verint_delta_y = verint_delta_x * lev1.cell_size * verint_delta_x;

            // TODO: sign deltas

            int horint_id_y = Math.floor((p.y_pos + horint_delta_y) / lev1.cell_size) * lev1.map_width;
            int horint_id_x = Math.floor((p.x_pos + horint_delta_x) / lev1.cell_size);
            int verint_id = 0;
        
            if(horint_id == 0; && verint_id == 0)
            {
                horizontal_iteration++;
                vertical_iteration++;
                continue;
            }

            float horint_length = (float)Math.sqrt(Math.pow(horint_delta_y, 2) + Math.pow(horint_delta_x, 2));
            float verint_length = (float)Math.sqrt(Math.pow(verint_delta_y, 2) + Math.pow(verint_delta_x, 2));

            if(horint_id != 0)
            {
                if(horint_length <= verint_length)
                {
                    // Calculate column height
                }
                vertical_iteration++;
            }
            if(verint_id != 0)
            {
                if(verint_length <= horint_length)
                {
                    // Calculate column height
                }
                horizontal_iteration++;
            }
        }
    }
}




/*for(int i = -p.fov/2; i <= p.fov/2; i++)
    {
        float column_height, wall_distance;
        float ray_rotation = p.rotation + i;
        float rotation_tangent = (float)Math.tan(Math.toRadians(ray_rotation));
        float ray_y = (float)Math.sin(Math.toRadians(ray_rotation));
        float ray_x = (float)Math.cos(Math.toRadians(ray_rotation));
        //print(ray_y + "\n");

        // Change in y from player's position to first horizontal interception
        float initial_horint_delta_y =  (ray_y > 0) ? p.y_pos - (float)Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size : 
                                        (ray_y < 0) ? p.y_pos - (float)Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size - lev1.cell_size : 0;
        // Change in x from player's position to first vertical interception
        float initial_verint_delta_x =  (ray_x > 0) ? (float)Math.floor(p.x_pos / lev1.cell_size) * lev1.cell_size + lev1.cell_size - p.x_pos :
                                        (ray_x < 0) ? (float)Math.floor(p.x_pos / lev1.cell_size) * lev1.cell_size - p.x_pos : 0;

        //print(initial_horint_delta_y + "\n");

        int horizontal_iteration = 0;
        int vertical_iteration = 0;
        while(true)
        {
            break;
            /*float horint_delta_y = initial_horint_delta_y + lev1.cell_size * horizontal_iteration;
            float horint_delta_x = horint_delta_y / rotation_tangent;
            //print(initial_horint_delta_y + "\n");
            //print(Math.ceil((p.y_pos - horint_delta_y - 1) / lev1.cell_size - 1) + "\n");
            //int horint_id = lev1.map[(int)(Math.floor((p.y_pos - horint_delta_y) / lev1.cell_size - 1) * lev1.map_width 
            //                            + Math.floor((p.x_pos + horint_delta_x) / lev1.cell_size + 1))];
            int horint_id = 0;

            float verint_delta_x = initial_verint_delta_x + lev1.cell_size * vertical_iteration;
            float verint_delta_y = verint_delta_x * rotation_tangent;
            //print(Math.floor((p.x_pos + initial_verint_delta_x + 1) / lev1.cell_size) + "\n");
            //int verint_id = lev1.map[(int)(Math.floor((p.y_pos - verint_delta_y) / lev1.cell_size - 1) * lev1.map_width
            //                            + Math.floor((p.x_pos + verint_delta_x) / lev1.cell_size + 1))];
            int verint_id = 0;

            if(horint_id == 0 && verint_id == 0)
            {
                //horizontal_iteration++;
                //vertical_iteration++;
                continue;
            }

            float horint_length = (float)Math.sqrt((float)Math.pow(horint_delta_y, 2) + (float)Math.pow(horint_delta_x, 2));
            float verint_length = (float)Math.sqrt((float)Math.pow(verint_delta_y, 2) + (float)Math.pow(verint_delta_x, 2));

            if(horint_id != 0)
            {
                if(horint_length <= verint_length)
                {
                    // Calculate column height
                    wall_distance = (float)Math.cos(i) * horint_length;
                    break;
                }
                //vertical_iteration++;
            }
            if(verint_id != 0)
            {
                if(verint_length <= horint_length)
                {
                    // Calculate column height
                    wall_distance = (float)Math.cos(i) * verint_length;
                    break;
                }
                //horizontal_iteration++;
            }
        }

        //column_height = 2 * height - scaling_factor * wall_distance;*/