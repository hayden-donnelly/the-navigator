import java.util.*; 

class Level
{
    int[] map;
    int map_width, map_height, map_area, cell_size;
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
    rectMode(CENTER);

    lev1 = new Level();
    int[] placeholder = {   1, 1, 1, 1, 1, 1, 1, 1,
                            1, 1, 0, 0, 0, 1, 1, 1,
                            1, 0, 0, 0, 0, 0, 1, 1,
                            1, 0, 0, 0, 0, 0, 0, 1,
                            1, 0, 0, 0, 0, 0, 0, 1,
                            1, 0, 0, 0, 0, 0, 0, 1,
                            1, 1, 1, 1, 1, 1, 1, 1 };
    lev1.map = placeholder;
    lev1.map_width = 8;
    lev1.map_height = 7;
    lev1.map_area = lev1.map_width * lev1.map_height;
    lev1.cell_size = 20;

    p = new Player();
    p.x_pos = 50;
    p.y_pos = 90;
    p.rotation = 30;
    p.fov = 60;

    // play around with this
    scaling_factor = 0.5;
}

float rot_dir = 1;

void draw()
{
    p.rotation += rot_dir;

    p.rotation = (p.rotation > 360) ? p.rotation - 360 : p.rotation;

    background(255);
    fill(200);

    ArrayList<Float> column_buffer = new ArrayList<Float>();
    // Iterate over every angle in player's FOV
    for(int i = -p.fov/2; i <= p.fov/2; i++)
    {
        int magic_number = 0;
        float distance_to_wall = 0;
        float absolute_ray_angle = p.rotation + i;
        absolute_ray_angle = (absolute_ray_angle < 0) ? 360 + absolute_ray_angle : absolute_ray_angle;
        float ray_y_sign = (float)Math.signum(Math.sin(Math.toRadians(absolute_ray_angle)));
        float ray_x_sign = (float)Math.signum(Math.cos(Math.toRadians(absolute_ray_angle)));
        float horint_angle = 0;
        float verint_angle = 0;
        float horint_angle_tangent = 0;
        float verint_angle_tangent = 0;
        // Change in y from player's position to first horizontal interception
        float initial_horint_delta_y = 0;
        // Change in x from player's position to first vertical interception
        float initial_verint_delta_x = 0;

        if(ray_x_sign > 0)
        {
            // Quadrants 1 or 4
            if(ray_y_sign > 0)
            {
                // Quadrant 1
                horint_angle = 90 - absolute_ray_angle;
                verint_angle = absolute_ray_angle;

                // Upper delta
                initial_horint_delta_y = (float)Math.abs(Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size - p.y_pos);

                magic_number = -1;
            }
            else if(ray_y_sign < 0)
            {
                // Quadrant 4
                horint_angle = absolute_ray_angle - 270;
                verint_angle = 360 - absolute_ray_angle;

                // Lower delta 
                initial_horint_delta_y = (float)Math.abs((Math.floor(p.y_pos / lev1.cell_size) + 1) * lev1.cell_size - p.y_pos);

                magic_number = 0;
            }

            // Right delta 
            initial_verint_delta_x = (float)Math.abs((Math.floor(p.x_pos / lev1.cell_size) + 1) * lev1.cell_size - p.x_pos);
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
                initial_horint_delta_y = (float)Math.abs(Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size - p.y_pos);

                magic_number = -1;
            }
            else if(ray_y_sign < 0)
            {
                // Quadrant 3
                horint_angle = 270 - absolute_ray_angle;
                verint_angle = absolute_ray_angle - 180;

                // Lower delta
                initial_horint_delta_y = (float)Math.abs((Math.floor(p.y_pos / lev1.cell_size) + 1) * lev1.cell_size - p.y_pos);

                magic_number = 0;
            }

            // Left delta
            initial_verint_delta_x = (float)Math.abs(Math.floor(p.x_pos / lev1.cell_size) * lev1.cell_size - p.x_pos);
        }
        else
        {
            // Ray is vertical
            if(ray_y_sign > 0)
            {
                // Upper delta
                initial_horint_delta_y = (float)Math.abs(Math.floor(p.y_pos / lev1.cell_size) * lev1.cell_size - p.y_pos);
            }
            else if(ray_y_sign < 0)
            {
                // Lower delta
                initial_horint_delta_y = (float)Math.abs((Math.floor(p.y_pos / lev1.cell_size) + 1) * lev1.cell_size - p.y_pos);
            }
        }

        horint_angle_tangent = (float)Math.tan(Math.toRadians(horint_angle));
        verint_angle_tangent = (float)Math.tan(Math.toRadians(verint_angle));

        // Find ray/grid interception points
        int horizontal_iteration = 0;
        int vertical_iteration = 0;
        while(true)
        {
            float horint_delta_y = initial_horint_delta_y + lev1.cell_size * horizontal_iteration;
            float horint_delta_x = horint_delta_y * horint_angle_tangent;
            horint_delta_y *= -ray_y_sign;
            horint_delta_x *= ray_x_sign;

            float verint_delta_x = initial_verint_delta_x + lev1.cell_size * vertical_iteration;
            float verint_delta_y = verint_delta_x * verint_angle_tangent;
            verint_delta_x *= ray_x_sign;
            verint_delta_y *= -ray_y_sign;

            int horint_id_y = (int)Math.floor((p.y_pos + horint_delta_y) / lev1.cell_size + magic_number) * lev1.map_width;
            int horint_id_x = (int)Math.floor((p.x_pos + horint_delta_x) / lev1.cell_size);
            int horint_id = (horint_id_x >= 0 && horint_id_x < lev1.map_width && horint_id_y >= 0 && horint_id_y < lev1.map_area) ? lev1.map[horint_id_y + horint_id_x] : 0;

            int verint_id_y = (int)Math.floor((p.y_pos + verint_delta_y) / lev1.cell_size) * lev1.map_width;
            int verint_id_x = (int)Math.floor((p.x_pos + verint_delta_x + ray_x_sign) / lev1.cell_size);
            int verint_id = (verint_id_x >= 0 && verint_id_x < lev1.map_width && verint_id_y >= 0 && verint_id_y < lev1.map_area) ? lev1.map[verint_id_y + verint_id_x] : 0;

            if(horint_id == 0 && verint_id == 0)
            {
                horizontal_iteration++;
                vertical_iteration++;
                continue;
            }

            float horint_length = (float)Math.sqrt(Math.pow(horint_delta_y, 2) + Math.pow(horint_delta_x, 2));
            float verint_length = (float)Math.sqrt(Math.pow(verint_delta_y, 2) + Math.pow(verint_delta_x, 2));

            if(horint_id != 0)
            {
                if(horint_length <= verint_length || verint_length == 0)
                {
                    distance_to_wall = (float)Math.cos(Math.toRadians(i)) * horint_length;
                    fill(0, 0, 255);
                    rect(700 + horint_delta_x*3, 500 + horint_delta_y*3, 10, 10);
                    break;
                }
                vertical_iteration++;
            }
            if(verint_id != 0)
            {
                if(verint_length <= horint_length || horint_length == 0)
                {
                    distance_to_wall = (float)Math.cos(Math.toRadians(i)) * verint_length;
                    fill(255, 0, 0);
                    rect(700 + verint_delta_x*3, 500 + verint_delta_y*3, 10, 10);
                    break;
                }
                horizontal_iteration++;
            }
        }

        float column_height = height - (distance_to_wall * 3);
        column_buffer.add(column_height);
    }

    // Draw buffer
    for(int i = 0; i <= p.fov; i++)
    {
        fill(200);
        rect(600 - 10*i, height/2, 10, column_buffer.get(i));
    }
}