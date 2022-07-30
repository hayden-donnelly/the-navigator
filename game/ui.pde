class UI
{
    Button[] main_menu_buttons;
    Button[] how_to_play_buttons;
    Button[] game_over_buttons;
    PFont title_font;
    PFont score_font;

    UI(Color_Palette ui_palette)
    {
        color ui_bg_color = color(ui_palette.c1);
        color ui_text_color = color(ui_palette.c4);

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

    // Checks if any button within a group of buttons has been
    // pressed and sets game state accordingly
    void update_buttons(Button[] button_arr)
    {
        for(int i = 0; i < button_arr.length; i++)
        {
            if(button_arr[i].check_click())
            {
                return;
            }
        }
    }

    void render_buttons(Button[] button_arr)
    {
        rectMode(CENTER);
        textAlign(CENTER, CENTER);
        for(int i = 0; i < button_arr.length; i++)
        {
            button_arr[i].render_button();
        }
    }

    void render_game_overlay(int score)
    {
        textFont(score_font);
        text("Score: " + score, 640, 30);
    }

    void render_main_menu()
    {
        background(palette.c1);
        textAlign(CENTER);
        fill(palette.c4);
        stroke(palette.c4);
        textFont(title_font);
        text("The Navigator", 640, 100);
        render_buttons(main_menu_buttons);
    }

    void render_how_to_play_menu()
    {
        background(palette.c1);
        text("\'W\' to Move Forward", 640, 100);
        text("\'S\' to Move Backward", 640, 150);
        text("\'A\' to Move Left", 640, 200);
        text("\'D\' to Move Right", 640, 250);
        text("\'Left Arrow\' to Rotate Left", 640, 300);
        text("\'Right Arrow\' to Rotate Right", 640, 350);
        text("Navigate to through the maze and reach the turquoise portal to win!", 640, 450);
        render_buttons(how_to_play_buttons);
    }

    void render_game_over_menu(String game_over_message, int score)
    {
        background(palette.c1);
        fill(palette.c4);
        textFont(title_font);
        text("GAME OVER", 640, 100);
        textFont(score_font);
        text(game_over_message, 640, 150);
        text("Score: " + score, 640, 200);
        text("Best Score: " + game.best_score, 640, 250);
        stroke(palette.c4);
        render_buttons(game_over_buttons);
    }
}