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
    int score;
    int best_score;
    String game_over_message;
    int score_add_counter;

    Game_States current_game_state;
    Game_States previous_game_state;

    Game_Manager()
    {
        score = 0;
        best_score = 1000000;
        game_over_message = "";
        score_add_counter = 0;

        current_game_state = Game_States.MAIN_MENU;
        previous_game_state = Game_States.HOW_TO_PLAY;
    }

    void increment_score()
    {
        score_add_counter++;
        if(score_add_counter >= 60)
        {
            score_add_counter = 0;
            score++;
        }
    }

    void reset_game()
    {
        score = 0;
        game_over_message = "";
    }

    void game_over()
    {
        set_game_state(Game_States.GAME_OVER);
        if(game.score < game.best_score)
        {
            game_over_message = "NEW BEST SCORE!";
            best_score = score;
        }
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
}