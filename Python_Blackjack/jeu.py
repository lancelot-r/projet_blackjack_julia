from carte import *
from deck import *
import keyboard

def jeu():
    # Instancier un deck de black jack
    blackjack_deck = create_blackjack()

    # On le mélange
    shuffle(blackjack_deck)

    # Instancier une main pour le dealer et le joueur
    player_hand = create_empty_hand()
    dealer_hand = create_empty_hand()

    # Distribution des cartes
    take_a_card(blackjack_deck,player_hand)
    take_a_card(blackjack_deck,dealer_hand)
    take_a_card(blackjack_deck,player_hand)

    # On affiche la main du dealer
    display_hand(dealer_hand,"dealer")
    hand_value_dealer = hand_value(dealer_hand)
    print("Current dealer hand value :")
    print(hand_value_dealer)

    # Boucle de jeu pour le joueur
    display_hand(player_hand,"player")
    hand_value_player = hand_value(player_hand)
    print("Current player hand value :")
    print(hand_value_player)
    refus = False
    while((hand_value_player<21) and (not refus)):
        print("Do you want to take a new card ? Press Y or N.")
        
        while True:
            if (keyboard.read_key() == "y") or (keyboard.read_key() == "Y") :
                print("You want a new card !")
                take_a_card(blackjack_deck,player_hand)
                display_hand(player_hand,"player")
                hand_value_player = hand_value(player_hand)
                print("Current player hand value :")
                print(hand_value_player)

                if hand_value_player > 21 :
                    print("You went above 21 ! You lost.")
                    return
                
                break
            elif (keyboard.read_key() == "n") or (keyboard.read_key() == "N") :
                print("Ok, no new card...")
                refus = True
                break
    
    #Résolution pour le dealer : il tire jusqu'à atteindre un minimum de 17
    display_hand(dealer_hand,"dealer")
    hand_value_dealer = hand_value(dealer_hand)
    print("Current dealer hand value :")
    print(hand_value_dealer)
    while hand_value_dealer < 17:
        take_a_card(blackjack_deck,dealer_hand)
        display_hand(dealer_hand,"dealer")
        hand_value_dealer = hand_value(dealer_hand)
        print("Current dealer hand value :")
        print(hand_value_dealer)

    # Affichage fin de partie
    if ((hand_value_player <= 21) and ((hand_value_dealer < hand_value_player) or hand_value_dealer > 21)):
        print("You won !")
    elif ((hand_value_dealer <= 21) and (hand_value_dealer > hand_value_player)):
        print("The dealer won...")
    else:
        print("Draw.")
    
    return
        
jeu()