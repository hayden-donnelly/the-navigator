enum Game_States
{
    MAIN_MENU,
    HOW_TO_PLAY,
    LEVEL_SELECT,
    IN_GAME,
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
        previous_game_state = Game_States.LEVEL_SELECT;
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
        print("\n" + mouseX);
        print("\n" + bg_x_corner);
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
Button[] level_select_buttons;

PFont title_font;

void setup()
{
    size(1280, 720);
    
    game = new Game_Manager();
    game.set_game_state(Game_States.MAIN_MENU);

    color ui_bg_color = color(1,1,43);
    color ui_text_color = color(5,217,232);

    main_menu_buttons = new Button[2];
    main_menu_buttons[0] = new Button("Level Select", 640, 200, 300, 50, 30, ui_bg_color, ui_text_color, Game_States.LEVEL_SELECT);
    main_menu_buttons[1] = new Button("How to Play", 640, 300, 300, 50, 30, ui_bg_color, ui_text_color, Game_States.HOW_TO_PLAY);

    title_font = createFont("Orenasolomayusculas.ttf", 32);
}

void draw()
{
    switch(game.current_game_state)
    {
        case IN_GAME:
            break;
        case MAIN_MENU:
            background(1,1,43);
            textAlign(CENTER);
            textSize(50);
            fill(5,217,232);
            stroke(255,42,109);
            textFont(title_font);
            text("Game Title", 640, 100);

            game.render_ui(main_menu_buttons);
            break;
        case HOW_TO_PLAY:
            game.render_ui(how_to_play_buttons);
            break;
        case LEVEL_SELECT:
            background(255);
            //game.render_ui(level_select_buttons);
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
        case LEVEL_SELECT:
            game.update_ui(level_select_buttons);
            break;
    } 
}
