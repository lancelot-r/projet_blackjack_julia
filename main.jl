module PlayGame

include("carte.jl")
using .CardDefinitions
include("deck.jl")
using .DeckDefinitions
include("jeu.jl")
using .GameDefinition

function game()
    blackjack_deck,player_hand,dealer_hand = GameDefinition.initialize_game()
    end_game = false
    GameDefinition.display_game(player_hand,dealer_hand,end_game)
    while !end_game
        blackjack_deck,player_hand,dealer_hand,end_game = GameDefinition.input_player(GameDefinition.input_terminal(),blackjack_deck,player_hand,dealer_hand)
        GameDefinition.display_game(player_hand,dealer_hand,end_game)
    end
end

export game

end