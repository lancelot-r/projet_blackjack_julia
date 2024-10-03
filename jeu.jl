include("carte.jl")
include("deck.jl")
function jeu()
    # Instancier un deck de black jack
    blackjack_deck = create_blackjack_deck(6)
    # Le melanger
    shuffle!(blackjack_deck)
    
    # Instancier une main pour le dealer et le joueur
    player_hand = create_empty_hand()
    dealer_hand = create_empty_hand()

    # Distribution des cartes
    take_a_card(blackjack_deck,player_hand)
    take_a_card(blackjack_deck,dealer_hand)
    take_a_card(blackjack_deck,player_hand)

    # Boucle de jeu pour le joueur
    hand_value_player = hand_value(player_hand)
    println("Current player hand value :")
    println(hand_value_player)
    refus = false
    while ((hand_value_player < 21) & refus == false)
        println("Do you want to take a new card ? Press Y or N.")
        input = ""
        while ((input != "Y") & (input != "y") & (input != "N") & (input != "n"))
            input = readline()
        end

        if ((input == "Y") || (input == "y"))
            println("You want a new card !")
            take_a_card(blackjack_deck,player_hand)
            hand_value_player = hand_value(player_hand)
            println("Current player hand value :")
            println(hand_value_player)
        elseif ((input == "N") || (input == "n"))
            println("Ok, no new card...")
            refus = true
        end
    end
    

    # Résolution pour le dealer : il tire jusqu'à atteindre un minimum de 17
    hand_value_dealer = hand_value(dealer_hand)
    println("Current dealer hand value :")
    println(hand_value_dealer)
    while (hand_value_dealer < 17)
        take_a_card(blackjack_deck,dealer_hand)
        hand_value_dealer = hand_value(dealer_hand)
        println("Current dealer hand value :")
        println(hand_value_dealer)
    end

    # Affichage fin de partie
    if ((hand_value_player <= 21) & ((hand_value_dealer < hand_value_player) | hand_value_dealer > 21))
        println("You won !")
    elseif ((hand_value_player <= 21) & (hand_value_dealer <= 21) & (hand_value_dealer > hand_value_player))
        println("The dealer won...")
    else
        println("Draw.")
    end
end

jeu()