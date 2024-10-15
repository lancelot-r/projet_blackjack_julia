# Load necessary library
library(dplyr)

# Include the code for creating cards and decks
source("Cartes_et_Deck.R")

# definir la fonction jeu
jeu <- function() {
  # Creer et melanger le deck de blackjack
  blackjack_deck_init <- create_blackjack_deck(6)
  blackjack_deck<- shuffle(blackjack_deck_init) #on fait shuffle, puisque blackjackdeck_init est un deck, ça va appeler la fct shuffle.deck

  # Creer des mains vides pour le joueur et le dealer
  player_hand <- create_empty_hand()
  dealer_hand <- create_empty_hand()
  
  # distribution initiale des cartes (2 pour le joueur, 1 pour le dealer)
  result <- take_a_card(blackjack_deck, player_hand)
  blackjack_deck <- result$pile
  player_hand <- result$hand
  
  
  result <- take_a_card(blackjack_deck, dealer_hand)
  blackjack_deck <- result$pile
  dealer_hand <- result$hand
  
  result <- take_a_card(blackjack_deck, player_hand)
  blackjack_deck <- result$pile
  player_hand <- result$hand
  
  # afficher la main du dealer
  display_hand(dealer_hand, "Dealer")
  hand_value_dealer <- hand_value(dealer_hand)
  cat("Current dealer hand value:", hand_value_dealer, "\n")
  
  # afficher la main et la valeur de la main du joueur
  display_hand(player_hand, "Player")
  hand_value_player <- hand_value(player_hand)
  cat("Current player hand value:", hand_value_player, "\n")
  
  # le tour du joueur pour prendre une carte(jusqu'il decide d'arreter ou si la main>21)
  refusal <- FALSE
  while (hand_value_player < 21 && !refusal) {
    cat("Do you want to take a new card? Press Y or N.\n")
    input <- readline()
    
    while (!input %in% c("Y", "y", "N", "n")) {
      cat("Please enter Y or N.\n")
      input <- readline()
    }
    
    if (input %in% c("Y", "y")) {
      cat("You want a new card!\n")
      result <- take_a_card(blackjack_deck, player_hand)
      player_hand <- result$hand
      display_hand(player_hand, "Player")
      hand_value_player <- hand_value(player_hand)
      cat("Current player hand value:", hand_value_player, "\n")
      
      if (hand_value_player > 21) {
        cat("You went above 21! You lost.\n")
      }
    } else if (input %in% c("N", "n")) {
      cat("Ok, no new card...\n")
      refusal <- TRUE
    }
  }
  
  # le tour du dealer: il prend des cartes tant que la main est moins que 17
  display_hand(dealer_hand, "Dealer")
  hand_value_dealer <- hand_value(dealer_hand)
  cat("Current dealer hand value:", hand_value_dealer, "\n")
  while (hand_value_dealer < 17) {
    result <- take_a_card(blackjack_deck, dealer_hand)
    dealer_hand <- result$hand
    display_hand(dealer_hand, "Dealer")
    hand_value_dealer <- hand_value(dealer_hand)
    cat("Current dealer hand value:", hand_value_dealer, "\n")
  }
  
  # Comparaison et decision du gagnant
  if (hand_value_player <= 21 && (hand_value_dealer > 21 || hand_value_player > hand_value_dealer)) {
    cat("You won!\n")
  } else if (hand_value_dealer <= 21 && hand_value_dealer > hand_value_player) {
    cat("The dealer won...\n")
  } else {
    cat("It's a draw.\n")
  }
}

# pour faire run au jeu
jeu()

