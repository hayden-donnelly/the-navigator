class Button
{
    String text; 
    float bg_x, bg_y, bg_w, bg_h, text_x, text_y;
    float bg_x_corner, bg_y_corner;
    PFont text_font;
    color bg_color, text_color;
    // Button changes to this game state when pressed
    Game_States target_game_state;

    Button(String text, float x, float y, float w, float h, String text_font, int text_size, color bg_color, color text_color, Game_States target_game_state)
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
        this.text_font = createFont(text_font, text_size);
        this.bg_color = bg_color;
        this.text_color = text_color;
        this.target_game_state = target_game_state;
    }

    void render_button()
    {
        fill(bg_color);
        rect(bg_x, bg_y, bg_w, bg_h);
        fill(text_color);
        textFont(text_font);
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