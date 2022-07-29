Game_Manager game;
Level lev1;
Button[] main_menu_buttons;
Button[] how_to_play_buttons;
Button[] game_over_buttons;
Color_Palette pal1;
PFont title_font;
PFont score_font;

void setup()
{
    size(1280, 720);
    rectMode(CENTER);
    lev1 = new Level();
    
    game = new Game_Manager();
    game.set_game_state(Game_States.MAIN_MENU);

    pal1 = new Color_Palette(color(34,32,53), 
                             color(87,82,103), 
                             color(141,137,128),
                             color(101,220,152),
                             color(160,255,227));

    color ui_bg_color = color(pal1.c1);
    color ui_text_color = color(pal1.c4);

    main_menu_buttons = new Button[2];
    main_menu_buttons[0] = new Button("Play", 640, 200, 300, 50, "conthrax-sb.ttf", 23, ui_bg_color, ui_text_color, Game_States.IN_GAME);
    main_menu_buttons[1] = new Button("How to Play", 640, 300, 300, 50, "conthrax-sb.ttf", 23, ui_bg_color, ui_text_color, Game_States.HOW_TO_PLAY);

    how_to_play_buttons = new Button[1];
    how_to_play_buttons[0] = new Button("Back", 1080, 40, 150, 80, "conthrax-sb.ttf", 23, ui_bg_color, ui_text_color, Game_States.BACK);

    game_over_buttons = new Button[2];
    game_over_buttons[0] = new Button("Play Again", 640, 350, 300, 50, "conthrax-sb.ttf", 23, ui_bg_color, ui_text_color, Game_States.IN_GAME);
    game_over_buttons[1] = new Button("Main Menu", 640, 450, 300, 50, "conthrax-sb.ttf", 23, ui_bg_color, ui_text_color, Game_States.MAIN_MENU);

    title_font = createFont("conthrax-sb.ttf", 40);
    score_font = createFont("conthrax-sb.ttf", 25);
}

void draw()
{
    switch(game.current_game_state)
    {
        case IN_GAME:
            game.increment_score();
            lev1.player_rotation();
            lev1.player_movement();

            if(lev1.check_if_player_has_won())
            {
                game.set_game_state(Game_States.GAME_OVER);
                if(game.score < game.best_score)
                {
                    game.game_over_message = "NEW BEST SCORE!";
                    game.best_score = score;
                }
            }

            lev1.render_level();
            textFont(score_font);
            text("Score: " + score, 640, 30);
            break;
        case MAIN_MENU:
            background(pal1.c1);
            textAlign(CENTER);
            fill(pal1.c4);
            stroke(pal1.c4);
            textFont(title_font);
            text("The Navigator", 640, 100);
            game.render_ui(main_menu_buttons);
            break;
        case HOW_TO_PLAY:
            background(pal1.c1);
            text("\'W\' to Move Forward", 640, 100);
            text("\'S\' to Move Backward", 640, 150);
            text("\'A\' to Move Left", 640, 200);
            text("\'D\' to Move Right", 640, 250);
            text("\'Left Arrow\' to Rotate Left", 640, 300);
            text("\'Right Arrow\' to Rotate Right", 640, 350);
            text("Navigate to through the maze and reach the turquoise portal to win!", 640, 450);
            game.render_ui(how_to_play_buttons);
            break;
        case GAME_OVER:
            background(pal1.c1);
            fill(pal1.c4);
            textFont(title_font);
            text("GAME OVER", 640, 100);
            textFont(score_font);
            text(game.game_over_message, 640, 150);
            text("Score: " + score, 640, 200);
            text("Best Score: " + game.best_score, 640, 250);
            stroke(pal1.c4);
            game.render_ui(game_over_buttons);
            break;
    }
}

void mousePressed()
{
    switch(game.current_game_state)
    {
        case MAIN_MENU:
            game.update_ui(main_menu_buttons);
            break;
        case HOW_TO_PLAY:
            game.update_ui(how_to_play_buttons);
            break;
        case GAME_OVER:
            // Generate new level
            lev1 = new Level();
            // Reset score
            game.game_over_message = "";
            game.score = 0;
            game.update_ui(game_over_buttons);
            break;
    } 
}

void keyPressed()
{
    if(key == 'w')
    {
        lev1.p.move_forward = 1;
    }
    else if(key == 's')
    {
        lev1.p.move_forward = -1;
    }
    else if(key == 'a')
    {
        lev1.p.move_right = 1;
    }
    else if(key == 'd')
    {
        lev1.p.move_right = -1;
    }
    else if(keyCode == LEFT)
    {
        lev1.p.rot_dir = 1;
    }
    else if(keyCode == RIGHT)
    {
        lev1.p.rot_dir = -1;
    }
}

void keyReleased()
{
    if((key == 'w' && lev1.p.move_forward == 1) || (key == 's' && lev1.p.move_forward == -1))
    {
        lev1.p.move_forward = 0;
    }
    else if((key == 'a' && lev1.p.move_right == 1) || (key == 'd' && lev1.p.move_right == -1))
    {
        lev1.p.move_right = 0;
    }
    else if((keyCode == LEFT && lev1.p.rot_dir == 1) || (keyCode == RIGHT && lev1.p.rot_dir == -1))
    {
        lev1.p.rot_dir = 0;
    }
}