module GameDefinition

include("carte.jl")
using .CardDefinitions
include("deck.jl")
using .DeckDefinitions
# import Pluto; Pluto.run()

function initialize_game()
    # Instancier un deck de black jack
    blackjack_deck = DeckDefinitions.create_blackjack_deck(6)
    # Le melanger
    shuffle!(blackjack_deck)
    
    # Instancier une main pour le dealer et le joueur
    player_hand = create_empty_hand()
    dealer_hand = create_empty_hand()

    # Distribution des cartes
    take_a_card(blackjack_deck,player_hand)
    take_a_card(blackjack_deck,dealer_hand)
    take_a_card(blackjack_deck,player_hand)

    return blackjack_deck,player_hand,dealer_hand
end

function display_game(player_hand,dealer_hand,end_game)
    # On affiche la main du joueur
    display_hand(player_hand,"player")
    hand_value_player = hand_value(player_hand)
    println("Current player hand value :")
    println(hand_value_player)
    
    # On affiche la main du dealer
    display_hand(dealer_hand,"dealer")
    hand_value_dealer = hand_value(dealer_hand)
    println("Current dealer hand value :")
    println(hand_value_dealer)

    # On affiche le message de fin de jeu si besoin
    if(end_game)
        if ((hand_value_player <= 21) && ((hand_value_dealer < hand_value_player) || hand_value_dealer > 21))
            println("You won !")
        elseif (hand_value_player>21)
            println("You went over 21, you lost.")
        elseif ((hand_value_dealer <= 21) && (hand_value_dealer > hand_value_player))
            println("The dealer won...")
        else
            println("Draw.")
         end
    end
    println("--------------------------------")
end

function input_terminal()
    println("Do you want to take a new card ? Press Y or N.")
    input = ""
    while !(input in ["Y", "y", "N", "n"])
        input = readline()
    end
    if input in ["Y", "y"]
        return "hit"
    elseif input in ["N", "n"]
        return "stand"
    end
end

function input_player(player_choice,blackjack_deck,player_hand,dealer_hand)
    if (player_choice=="hit")
           take_a_card(blackjack_deck,player_hand)
           return blackjack_deck,player_hand,dealer_hand,hand_value(player_hand)>21
    elseif (player_choice=="stand")
        # Résolution pour le dealer : il tire jusqu'à atteindre un minimum de 17
        hand_value_dealer = hand_value(dealer_hand)
        while (hand_value_dealer < 17)
            take_a_card(blackjack_deck,dealer_hand)
            hand_value_dealer = hand_value(dealer_hand)
        end
        return blackjack_deck,player_hand,dealer_hand,true
    end
end


export initialize_game, display_game, input_player, input_terminal

end
