Game_Manager game;
Level level;
Color_Palette palette;
UI ui;

void setup()
{
    size(1280, 720);
    rectMode(CENTER);

    level = new Level();
    game = new Game_Manager();
    game.set_game_state(Game_States.MAIN_MENU);

    palette = new Color_Palette(color(34,32,53), 
                             color(87,82,103), 
                             color(141,137,128),
                             color(101,220,152),
                             color(160,255,227));

    ui = new UI(palette);
}

void draw()
{
    switch(game.current_game_state)
    {
        case IN_GAME:
            game.increment_score();
            level.player_rotation();
            level.player_movement();

            if(level.player_has_reached_portal())
            {
                game.game_over();
            }

            level.render_level();
            ui.render_game_overlay(game.score);
            break;
        case MAIN_MENU:
            ui.render_main_menu();
            break;
        case HOW_TO_PLAY:
            ui.render_how_to_play_menu();
            break;
        case GAME_OVER:
            ui.render_game_over_menu(game.game_over_message, game.score);
            break;
    }
}

void mousePressed()
{
    switch(game.current_game_state)
    {
        case MAIN_MENU:
            ui.update_buttons(ui.main_menu_buttons);
            break;
        case HOW_TO_PLAY:
            ui.update_buttons(ui.how_to_play_buttons);
            break;
        case GAME_OVER:
            level = new Level();
            game.reset_game();
            ui.update_buttons(ui.game_over_buttons);
            break;
    } 
}

void keyPressed()
{
    if(key == 'w')
    {
        level.p.move_forward = 1;
    }
    else if(key == 's')
    {
        level.p.move_forward = -1;
    }
    else if(key == 'a')
    {
        level.p.move_right = 1;
    }
    else if(key == 'd')
    {
        level.p.move_right = -1;
    }
    else if(keyCode == LEFT)
    {
        level.p.rot_dir = 1;
    }
    else if(keyCode == RIGHT)
    {
        level.p.rot_dir = -1;
    }
}

void keyReleased()
{
    if((key == 'w' && level.p.move_forward == 1) 
        || (key == 's' && level.p.move_forward == -1))
    {
        level.p.move_forward = 0;
    }
    else if((key == 'a' && level.p.move_right == 1) 
             || (key == 'd' && level.p.move_right == -1))
    {
        level.p.move_right = 0;
    }
    else if((keyCode == LEFT && level.p.rot_dir == 1) 
             || (keyCode == RIGHT && level.p.rot_dir == -1))
    {
        level.p.rot_dir = 0;
    }
}