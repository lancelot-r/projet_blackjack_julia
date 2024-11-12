library(dplyr)

# Inclure les fichiers du jeu
source("Cartes_et_Deck.R")

#Fonction d'initialisation du jeu
initialize_game <- function(){
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
 
  return(list(blackjack_deck,player_hand,dealer_hand))
}

#Fontion d'affichage du statut de la partie
display_game <- function(player_hand, dealer_hand, end_game){
  # afficher la main du dealer
  display_hand(dealer_hand, "Dealer")
  hand_value_dealer <- hand_value(dealer_hand)
  cat("Current dealer hand value:", hand_value_dealer, "\n")
  
  # afficher la main et la valeur de la main du joueur
  display_hand(player_hand, "Player")
  hand_value_player <- hand_value(player_hand)
  cat("Current player hand value:", hand_value_player, "\n")
if(end_game){ 
  # Comparaison et decision du gagnant
  if (hand_value_player <= 21 && (hand_value_dealer > 21 || hand_value_player > hand_value_dealer)) {
    cat("You won!\n")
  } else if ((hand_value_dealer <= 21 && hand_value_dealer > hand_value_player) || hand_value_player > 21) {
    cat("The dealer won...\n")
  } else {
    cat("It's a draw.\n")
  }
  
}
  cat("----------------------\n")
}
input_player <- function(player_choice,blackjack_deck,player_hand,dealer_hand){
 if (player_choice=="hit"){
  result<- take_a_card(blackjack_deck,player_hand)
  player_hand <- result$hand
    return(list(blackjack_deck,player_hand,dealer_hand,hand_value(player_hand)>=21))
   
 }
  else if (player_choice=="stand")
   while (hand_value(dealer_hand) < 17) {
    result <- take_a_card(blackjack_deck, dealer_hand)
    dealer_hand <- result$hand
   }
  return (list(blackjack_deck,player_hand,dealer_hand,TRUE))
}

input_terminal<- function(){
  
    cat("Do you want to take a new card? Press Y or N.\n")
    input <- readline()
    
    while (!input %in% c("Y", "y", "N", "n")) {
      cat("Please enter Y or N.\n")
      input <- readline()
    }
    if (input %in% c("Y", "y")) {
      return("hit")
    }
    else if (input %in% c("N", "n")) {
      return("stand")
      
    }
  
}

# definir la fonction jeu
jeu <- function() {
  init <- initialize_game()
  blackjack_deck <- init[[1]]
  player_hand <- init[[2]]
  dealer_hand <- init[[3]]
  end_game <- FALSE
  display_game(player_hand, dealer_hand, FALSE)
  while (!end_game){
    input <- input_player(input_terminal(), blackjack_deck, player_hand, dealer_hand)
    blackjack_deck <- input[[1]]
    player_hand <- input[[2]]
    dealer_hand <- input[[3]]
    end_game <- input[[4]]
  display_game(player_hand, dealer_hand, end_game)
  }
}

