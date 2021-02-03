enum Game_States
{
    MAIN_MENU,
    IN_GAME,
    HOW_TO_PLAY,
    GAME_OVER,
    // Selecting this game state returns the game to the previous game state
    BACK
}

class Game_Manager
{
    Game_States current_game_state;
    Game_States previous_game_state;

    Game_Manager()
    {
        current_game_state = Game_States.MAIN_MENU;
        previous_game_state = Game_States.HOW_TO_PLAY;
    }

    // Sets new game state
    void set_game_state(Game_States gs)
    {
        previous_game_state = current_game_state;
        current_game_state = gs;
    }

    // Returns to the previous game state
    void set_previous_game_state()
    {
        current_game_state = previous_game_state;
    }

    void render_ui(Button[] button_arr)
    {
        rectMode(CENTER);
        textAlign(CENTER, CENTER);
        for(int i = 0; i < button_arr.length; i++)
        {
            button_arr[i].render_button();
        }
    }

    // Checks if any button within a group of buttons has been pressed and sets game state accordingly
    void update_ui(Button[] button_arr)
    {
        for(int i = 0; i < button_arr.length; i++)
        {
            if(button_arr[i].check_click())
            {
                return;
            }
        }
    }
}
Game_Manager game;

class Button
{
    String text; 
    float bg_x, bg_y, bg_w, bg_h, text_x, text_y;
    float bg_x_corner, bg_y_corner;
    int text_size;
    color bg_color, text_color;
    // Button changes to this game state when pressed
    Game_States target_game_state;

    Button(String text, float x, float y, float w, float h, int text_size, color bg_color, color text_color, Game_States target_game_state)
    {
        this.text = text;
        this.bg_x = x;
        this.bg_y = y;
        this.bg_w = w;
        this.bg_h = h;
        this.text_x = x;
        this.text_y = y;
        this.bg_x_corner = x - (w/2);
        this.bg_y_corner = y - (h/2);
        this.text_size = text_size;
        this.bg_color = bg_color;
        this.text_color = text_color;
        this.target_game_state = target_game_state;
    }

    void render_button()
    {
        fill(bg_color);
        rect(bg_x, bg_y, bg_w, bg_h);
        fill(text_color);
        textSize(text_size);
        text(text, text_x, text_y);
    }

    // Checks if this button has been clicked on
    boolean check_click()
    {
        if(mouseX >= bg_x_corner && mouseX <= bg_x_corner+bg_w && mouseY >= bg_y_corner && mouseY <= bg_y_corner+bg_h)
        {
            if(target_game_state != Game_States.BACK)
            {
                game.set_game_state(target_game_state);
            }
            else
            {
                game.set_previous_game_state();
            }
            return true;
        }
        return false;
    }
}
Button[] main_menu_buttons;
Button[] how_to_play_buttons;

PFont title_font;

void setup()
{
    size(1280, 720);
    rectMode(CENTER);
    lev1 = new Level();
    
    game = new Game_Manager();
    game.set_game_state(Game_States.MAIN_MENU);

    color ui_bg_color = color(1,1,43);
    color ui_text_color = color(5,217,232);

    main_menu_buttons = new Button[2];
    main_menu_buttons[0] = new Button("Play", 640, 200, 300, 50, 30, ui_bg_color, ui_text_color, Game_States.IN_GAME);
    main_menu_buttons[1] = new Button("How to Play", 640, 300, 300, 50, 30, ui_bg_color, ui_text_color, Game_States.HOW_TO_PLAY);

    how_to_play_buttons = new Button[1];
    how_to_play_buttons[0] = new Button("Back", 1080, 40, 150, 80, 30, ui_bg_color, ui_text_color, Game_States.BACK);

    title_font = createFont("Orenasolomayusculas.ttf", 32);
}

void draw()
{
    switch(game.current_game_state)
    {
        case IN_GAME:
            lev1.p.rotation += rot_dir;
            lev1.p.rotation = (lev1.p.rotation > 360) ? lev1.p.rotation - 360 : lev1.p.rotation;
            lev1.render_level();
            break;
        case MAIN_MENU:
            background(1,1,43);
            textAlign(CENTER);
            textSize(50);
            fill(5,217,232);
            stroke(255,42,109);
            textFont(title_font);
            text("The Impostor", 640, 100);

            game.render_ui(main_menu_buttons);
            break;
        case HOW_TO_PLAY:
            background(1,1,43);
            game.render_ui(how_to_play_buttons);
            break;
    }
}

void mousePressed()
{
    switch(game.current_game_state)
    {
        case IN_GAME:
            // shoot gun
            break;
        case MAIN_MENU:
            game.update_ui(main_menu_buttons);
            break;
        case HOW_TO_PLAY:
            game.update_ui(how_to_play_buttons);
            break;
    } 
}