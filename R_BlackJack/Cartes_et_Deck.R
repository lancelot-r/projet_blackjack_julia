library(dplyr)

#definir une fct avec use method (pour utiliser explicitemnet le single dispatching)
shuffle = function(obj, ...) UseMethod("shuffle")

#definir suits et ranks
suits <- c("clubs","spades","hearts","diamonds")
ranks <- c("ace","2","3","4","5","6","7","8","9","10","jack","queen","king")

#faire un dict pour les valeurs des cartes
dico_card_value <- c(
  "ace" = 1,
  "2" = 2,
  "3" = 3,
  "4" = 4,
  "5" = 5,
  "6" = 6,
  "7" = 7,
  "8" = 8,
  "9" = 9,
  "10" = 10,
  "jack" = 10,
  "queen" = 10,
  "king" = 10
)

# Creer des classes S3 pour "Card"
Card <- function(suit, rank) {
  structure(list(suit = suit, rank = rank), class = "Card")
}

print.Card <- function(card,...) {
  cat(card$suit, ": ", card$rank)
}

# Creer des class S3 pour "Deck" qui contient plusieurs cartes
Deck <- function(cards = list()) {
  structure(list(cards = cards), class = "Deck")
}

#fct pour melanger le deck (on appelle la fct shuffle definie avant)
shuffle.Deck <- function(deck) {
  Deck(sample(deck$cards))
}


# Fonction pour creer le deck
create_deck_52 <- function() {
  cards <- list()
  for (suit in suits) {
    for (rank in ranks) {
      cards <- append(cards, list(Card(suit, rank)))
    }
  }
  return(Deck(cards))
}

# Fonction pour joindre plusieurs decks dans un seul
concatene_decks <- function(decks) {
  all_cards <- list()
  for (deck in decks) {
    all_cards <- append(all_cards, deck$cards)
  }
  return(Deck(all_cards))
}

# fct pour creer un deck pour blackjack (6xdeck)
create_blackjack_deck <- function(num_decks = 6) {
  # Creer un seul deck
  deck_52 <- create_deck_52()
  # repeter le deck pour num_deck fois
  full_deck_list <- replicate(num_decks, deck_52, simplify = FALSE)
  return(concatene_decks(full_deck_list))
}


# fct pour calculer la valeur de la main
hand_value <- function(hand) {
  value <- 0
  aces <- 0
  for (card in hand$cards) {
    rank <- card$rank
    if (rank == "ace") {
      value <- value + 11
      aces <- aces + 1
    } else {
      value <- value + dico_card_value[[rank]]
    }
  }
  
  # ajuster pour les as, si la valeur de la main > 21
  while (value > 21 && aces > 0) {
    value <- value - 10
    aces <- aces - 1
  }
  
  return(value)
}

# fct pour creer un main vide (un deck sans cartes)
create_empty_hand <- function() {
  return(Deck(list()))
}

# fct pour prendre un carte du deck et la donner au joueur ou au dealer
take_a_card <- function(pile, hand) {
  new_card <- pile$cards[[1]]
  pile$cards <- pile$cards[-1]
  hand$cards <- append(hand$cards, list(new_card))
  return(list(pile = pile, hand = hand))
}


# fct pour montrer les cartes ds la main du joueur
display_hand <- function(hand, name = "Player") {
  cat("The", name, "hand: ")
  for (card in hand$cards) {
    cat(card$rank, "of", card$suit, ", ")
  }
  cat("\n")
}

