using Colors
using GameZero

WIDTH = 800
HEIGHT = 600
BACKGROUND = colorant"green"
MARGIN_Y = 50

DEALER_W = 400
DEALER_H = 200
DEALER_X = 800 - DEALER_W ÷ 2
DEALER_Y = 0 + MARGIN_Y

PLAYER_W = 400
PLAYER_H = 200
PLAYER_X = 800 - PLAYER_W ÷ 2
PLAYER_Y = HEIGHT * 2 - PLAYER_H - MARGIN_Y

dealer_card_space = Rect(DEALER_X, DEALER_Y, DEALER_W, DEALER_H)
player_card_space = Rect(PLAYER_X, PLAYER_Y, PLAYER_W, PLAYER_H)
player_score = Circle(PLAYER_X + PLAYER_W + 100, PLAYER_Y + PLAYER_H ÷ 4, 50)
dealer_score = Circle(DEALER_X + DEALER_W + 100, DEALER_Y + DEALER_H ÷ 4 * 3, 50)

start_game_button = Rect(100, 800, 50, 50)
test = Circle(100, 500, 50)

function draw(g::Game)
    draw(dealer_card_space, colorant"black", fill=true)
    draw(player_card_space, colorant"black", fill=true)
    draw(player_score, colorant"white", fill=true)
    draw(dealer_score, colorant"white", fill=true)
    draw(start_game_button, colorant"blue", fill=true)
end

function on_key_down(g::Game, k)
    if k == Keys.SPACE
        println("Key pressed: $k")
        draw(test, colorant"blue", fill=true)
    end
end

function on_mouse_down(g::Game, pos)
    if pos[1] >= start_game_button.x && pos[1] <= (start_game_button.x + start_game_button.w) &&
       pos[2] >= start_game_button.y && pos[2] <= (start_game_button.y + start_game_button.h)
        println("Mouse clicked at: $pos")
        draw(test, colorant"blue", fill=true)
    end
end