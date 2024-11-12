module PlayGame

include("carte.jl")
using .CardDefinitions
include("deck.jl")
using .DeckDefinitions
include("jeu.jl")
using .GameDefinition

"""
Fonction d'initialisation d'une partie
"""
function game()
    blackjack_deck, player_hand, dealer_hand = GameDefinition.initialize_game()
    GameDefinition.display_game(player_hand, dealer_hand, false)
    play_turn(blackjack_deck, player_hand, dealer_hand)
end

# Fonction pour chaque tour du jeu
"""
Fonction de tour de jeu avec un Deck blackjack_deck (pile de carte), un Deck player_hand (main joueur) et dealer_hand (main du dealer)
"""
function play_turn(blackjack_deck, player_hand, dealer_hand)
    player_choice = GameDefinition.input_terminal()
    blackjack_deck, player_hand, dealer_hand, end_game = GameDefinition.input_player(player_choice, blackjack_deck, player_hand, dealer_hand)
    GameDefinition.display_game(player_hand, dealer_hand, end_game)

    #appeler la fct play_turn si le jeu n'est pas game over
    if !end_game
        play_turn(blackjack_deck, player_hand, dealer_hand)
    end
end

export game, play_turn

end
