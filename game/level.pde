import java.util.*; 

class Level
{
    int[] map;
    int map_width, map_height, map_area, cell_size;

    class Entity
    {
        int x_pos, y_pos, fov;
        float rotation;
    }
    Entity p;

    Level()
    {
        // TODO: build write level generation algorithhm here

        int[] p2 = {    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                        1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
                        1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
                        1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
                        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
                        1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
                        1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
                        1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
                        1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
                        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        map = p2;
        map_width = 18;
        map_height = 11;
        map_area = map_width * map_height;
        cell_size = 20;

        p = new Entity(); 
        p.x_pos = 50;
        p.y_pos = 90;
        p.rotation = 30;
        p.fov = 60;
    }

    // Renders the entire level (map and entities) to the screen
    void render_level()
    {
        ArrayList<Float> map_buffer = render_map_to_buffer();

        noStroke();
        background(34,32,53);
        fill(87,82,103);
        rect(640, 540, 1280, 360);
        fill(200);

        // Draw buffer
        for(int i = 0; i <= p.fov*2; i++)
        {
            fill(141,137,128);
            rect(1280 - 11*i, height/2, 12, map_buffer.get(i));
        }
    }

    ArrayList<Float> render_map_to_buffer()
    {
        ArrayList<Float> column_buffer = new ArrayList<Float>();
        // Iterate over every angle in player's FOV
        for(float i = -p.fov/2; i <= p.fov/2; i+=0.5)
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
                    initial_horint_delta_y = (float)Math.abs(Math.floor(p.y_pos / cell_size) * cell_size - p.y_pos);

                    magic_number = -1;
                }
                else if(ray_y_sign < 0)
                {
                    // Quadrant 4
                    horint_angle = absolute_ray_angle - 270;
                    verint_angle = 360 - absolute_ray_angle;

                    // Lower delta 
                    initial_horint_delta_y = (float)Math.abs((Math.floor(p.y_pos / cell_size) + 1) * cell_size - p.y_pos);

                    magic_number = 0;
                }

                // Right delta 
                initial_verint_delta_x = (float)Math.abs((Math.floor(p.x_pos / cell_size) + 1) * cell_size - p.x_pos);
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
                    initial_horint_delta_y = (float)Math.abs(Math.floor(p.y_pos / cell_size) * cell_size - p.y_pos);

                    magic_number = -1;
                }
                else if(ray_y_sign < 0)
                {
                    // Quadrant 3
                    horint_angle = 270 - absolute_ray_angle;
                    verint_angle = absolute_ray_angle - 180;

                    // Lower delta
                    initial_horint_delta_y = (float)Math.abs((Math.floor(p.y_pos / cell_size) + 1) * cell_size - p.y_pos);

                    magic_number = 0;
                }

                // Left delta
                initial_verint_delta_x = (float)Math.abs(Math.floor(p.x_pos / cell_size) * cell_size - p.x_pos);
            }
            else
            {
                // Ray is vertical
                if(ray_y_sign > 0)
                {
                    // Upper delta
                    initial_horint_delta_y = (float)Math.abs(Math.floor(p.y_pos / cell_size) * cell_size - p.y_pos);
                }
                else if(ray_y_sign < 0)
                {
                    // Lower delta
                    initial_horint_delta_y = (float)Math.abs((Math.floor(p.y_pos / cell_size) + 1) * cell_size - p.y_pos);
                }
            }

            horint_angle_tangent = (float)Math.tan(Math.toRadians(horint_angle));
            verint_angle_tangent = (float)Math.tan(Math.toRadians(verint_angle));

            // Find ray/grid interception points
            int horizontal_iteration = 0;
            int vertical_iteration = 0;
            while(true)
            {
                float horint_delta_y = initial_horint_delta_y + cell_size * horizontal_iteration;
                float horint_delta_x = horint_delta_y * horint_angle_tangent;
                horint_delta_y *= -ray_y_sign;
                horint_delta_x *= ray_x_sign;

                float verint_delta_x = initial_verint_delta_x + cell_size * vertical_iteration;
                float verint_delta_y = verint_delta_x * verint_angle_tangent;
                verint_delta_x *= ray_x_sign;
                verint_delta_y *= -ray_y_sign;

                int horint_id_y = (int)Math.floor((p.y_pos + horint_delta_y) / cell_size + magic_number) * map_width;
                int horint_id_x = (int)Math.floor((p.x_pos + horint_delta_x) / cell_size);
                int horint_id = (horint_id_x >= 0 && horint_id_x < map_width && horint_id_y >= 0 && horint_id_y < map_area) ? map[horint_id_y + horint_id_x] : 0;

                int verint_id_y = (int)Math.floor((p.y_pos + verint_delta_y) / cell_size) * map_width;
                int verint_id_x = (int)Math.floor((p.x_pos + verint_delta_x + ray_x_sign) / cell_size);
                int verint_id = (verint_id_x >= 0 && verint_id_x < map_width && verint_id_y >= 0 && verint_id_y < map_area) ? map[verint_id_y + verint_id_x] : 0;

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
                        break;
                    }
                    vertical_iteration++;
                }
                if(verint_id != 0)
                {
                    if(verint_length <= horint_length || horint_length == 0)
                    {
                        distance_to_wall = (float)Math.cos(Math.toRadians(i)) * verint_length;
                        break;
                    }
                    horizontal_iteration++;
                }
            }

            float column_height = 20000/distance_to_wall;
            column_buffer.add(column_height);
        }

        return column_buffer;
    }
}
Level lev1;
float rot_dir = 0.5;