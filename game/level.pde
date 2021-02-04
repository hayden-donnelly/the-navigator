import java.util.*; 

class Level
{
    int[] map;
    int map_width, map_height, map_area, cell_size;

    class Entity
    {
        float x_pos, y_pos, fov;
        float move_forward, move_right;
        float rotation;
    }
    Entity p;

    Level()
    {
        p = new Entity(); 
        p.rotation = 30;
        p.move_forward = 0;
        p.move_right = 0;
        p.fov = 60;

        // Procedural level generation
        map_width = 100;
        map_height = 100;
        map_area = map_width * map_height;
        map = new int[map_area];
        cell_size = 30;

        int max_room_width = 10;
        int min_room_width = 9;
        int max_room_height = 10;
        int min_room_height = 9;
        int number_of_rooms = 10;

        for(int i = 0; i < map_area; i++)
        {
            map[i] = 1;
        }

        int prev_room_center_x = -1;
        int prev_room_center_y = -1;

        for(int i = 0; i < number_of_rooms; i++)
        {
            int room_width = (int)random(min_room_width, max_room_width);
            int room_height = (int)random(min_room_height, max_room_height);
            int room_x = (int)random(1, map_width - room_width-1);
            int room_y = (int)random(1, map_height - room_height-1);

            for(int x = room_x; x < room_x + room_width; x++)
            {
                for(int y = room_y; y < room_y + room_height; y++)
                {
                    map[y * map_width + x] = 0;
                }
            }

            int room_center_x = room_x + room_width/2;
            int room_center_y = room_y + room_height/2;

            if(prev_room_center_x != -1)
            {
                // Connect current and previous rooms
                int path_dir_x = (int)Math.signum(prev_room_center_x - room_center_x);
                int path_dir_y = (int)Math.signum(prev_room_center_y - room_center_y);

                for(int x = room_center_x; x != prev_room_center_x + path_dir_x; x += path_dir_x)
                {
                    map[room_center_y * map_width + x] = 0;
                }

                for(int y = room_center_y; y != prev_room_center_y + path_dir_y; y += path_dir_y)
                {
                    map[y * map_width + prev_room_center_x] = 0;
                }
            }
            else
            {
                p.x_pos = room_center_x*cell_size;
                p.y_pos = room_center_y*cell_size;
            }

            prev_room_center_x = room_center_x;
            prev_room_center_y = room_center_y;
        }

        /*for(int x = 0; x < map_width; x++)
        {
            for(int y = 0; y < map_height; y++)
            {
                print(map[y * map_width + x] + " ");
            }
            print("\n");
        }*/
    }

    // Renders the entire level (map and entities) to the screen
    void render_level()
    {
        ArrayList<Float> map_buffer = render_map_to_buffer();

        noStroke();
        background(pal1.c1);
        fill(pal1.c2);
        rect(640, 540, 1280, 360);

        // Draw buffer
        fill(pal1.c3);
        for(int i = 0; i <= p.fov*2; i++)
        {
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
float rot_dir = 0;