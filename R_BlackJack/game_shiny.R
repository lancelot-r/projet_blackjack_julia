# Assurez-vous d'importer les bibliothèques nécessaires
library(shiny)
library(bslib)
library(dplyr)

# Inclure les fichiers du jeu
source("Cartes_et_Deck.r")
source("le_jeu.r")

# Interface utilisateur
ui <- page_fluid(
  titlePanel("Blackjack Game"),
  layout_columns(
    card(
      card_header("Controls"),
      actionButton("hit", "Hit"),
      actionButton("stand", "Stand"),
      actionButton("new_game", "New Game")
    ),
    card(
      card_header("Game Status"),
      textOutput("dealer_hand_display"),
      textOutput("player_hand_display"),
      textOutput("game_result")
    )
  )
)

# Serveur
server <- function(input, output, session) {
  # Variables réactives pour stocker l'état du jeu
  blackjack_deck <- reactiveVal()
  player_hand <- reactiveVal()
  dealer_hand <- reactiveVal()
  game_end <- reactiveVal(FALSE)
  
  # Fonction d'initialisation du jeu (nouvelle partie)
  start_new_game <- function() {
    init <- initialize_game()
    blackjack_deck(init[[1]])
    player_hand(init[[2]])
    dealer_hand(init[[3]])
    game_end(FALSE)
  }
  
  # Affichage de la main du dealer
  output$dealer_hand_display <- renderText({
    paste("Dealer's Hand:", 
          paste(sapply(dealer_hand()$cards, function(card) paste(card$rank, "of", card$suit)), collapse = ",\n "),
          "Value:", hand_value(dealer_hand()))
  })
  
  # Affichage de la main du joueur
  output$player_hand_display <- renderText({
    paste("Player's Hand:", 
          paste(sapply(player_hand()$cards, function(card) paste(card$rank, "of", card$suit)), collapse = ",\n "),
          "Value:", hand_value(player_hand()))
  })
  
  # Affichage du résultat du jeu
  output$game_result <- renderText({
    if (game_end()) {
      dealer_val <- hand_value(dealer_hand())
      player_val <- hand_value(player_hand())
      if (player_val <= 21 && (dealer_val > 21 || player_val > dealer_val)) {
        "You won!"
      } else if (dealer_val <= 21 && dealer_val > player_val) {
        "The dealer won..."
      } else {
        "It's a draw."
      }
    } else {
      "Game in progress..."
    }
  })
  
  # Début d'une nouvelle partie
  observeEvent(input$new_game, {
    start_new_game()
  })
  
  # Action du bouton "Hit" pour piocher une carte pour le joueur
  observeEvent(input$hit, {
    if (!game_end()) {
      res <- take_a_card(blackjack_deck(), player_hand())
      blackjack_deck(res$pile)
      player_hand(res$hand)
      if (hand_value(player_hand()) >= 21) {
        game_end(TRUE)  # Fin de la partie si le joueur dépasse 21
      }
    }
  })
  
  # Action du bouton "Stand" pour que le dealer joue sa main
  observeEvent(input$stand, {
    if (!game_end()) {
      while (hand_value(dealer_hand()) < 17) {
        res <- take_a_card(blackjack_deck(), dealer_hand())
        blackjack_deck(res$pile)
        dealer_hand(res$hand)
      }
      game_end(TRUE)  # Fin de la partie après le tour du dealer
    }
  })
  
  # Initialisation de la première partie
  start_new_game()
}

# Lancer l'application Shiny
shinyApp(ui = ui, server = server)

