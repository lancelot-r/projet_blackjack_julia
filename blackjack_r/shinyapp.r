library(shiny)
library(dplyr)

# Source the game logic files
source("Cartes_et_Deck.R")

# Fonction pour initialiser le jeu
initialize_game <- function() {
  init <- create_blackjack_deck(6) %>% shuffle()
  list(deck = init, player_hand = create_empty_hand(), dealer_hand = create_empty_hand())
}

# Fonction pour générer le nom du fichier pour l'image de la carte
get_card_image <- function(card) {
  paste0(card$rank, "_of_", card$suit, ".png")
}

# Créer l'app Shiny
ui <- fluidPage(
  titlePanel("Blackjack Game with Images"),
  sidebarLayout(
    sidebarPanel(
      actionButton("new_game", "New Game"),
      actionButton("hit", "Hit"),
      actionButton("stand", "Stand")
    ),
    mainPanel(
      h3("Dealer's Hand"),
      uiOutput("dealer_hand_images"),
      h3("Player's Hand"),
      uiOutput("player_hand_images"),
      verbatimTextOutput("game_status")
    )
  )
)

server <- function(input, output, session) {
  game <- reactiveValues(deck = NULL, player_hand = NULL, dealer_hand = NULL, end_game = FALSE)
  
  # Fonction pour commencer le jeu
  start_new_game <- function() {
    init <- initialize_game()
    game$deck <- init$deck
    game$player_hand <- init$player_hand
    game$dealer_hand <- init$dealer_hand
    game$end_game <- FALSE
    
    # Distribuer les cartes initiales
    game <- deal_initial_cards(game)
  }
  
  # Fonction pour distribuer les cartes initiales
  deal_initial_cards <- function(game) {
    result <- take_a_card(game$deck, game$player_hand)
    game$deck <- result$pile
    game$player_hand <- result$hand
    
    result <- take_a_card(game$deck, game$dealer_hand)
    game$deck <- result$pile
    game$dealer_hand <- result$hand
    
    result <- take_a_card(game$deck, game$player_hand)
    game$deck <- result$pile
    game$player_hand <- result$hand
    
    return(game)
  }
  
  # Fontion pour faire render aux images des cartes
  render_hand_images <- function(hand) {
    card_images <- lapply(hand$cards, function(card) {
      img_src <- paste0("https://raw.githubusercontent.com/malnoe/Cours_M1_Remy/main/www/", get_card_image(card))
      tags$img(src = img_src, height = "100px", style = "margin: 5px;")
    })
    do.call(tagList, card_images)
  }
  
  # Afficher les images de la main du dealer
  output$dealer_hand_images <- renderUI({
    if (is.null(game$dealer_hand)) return(NULL)
    render_hand_images(game$dealer_hand)
  })
  
  # Afficher les images de la main du joueur
  output$player_hand_images <- renderUI({
    if (is.null(game$player_hand)) return(NULL)
    render_hand_images(game$player_hand)
  })
  
  # Afficher le statut du jeu
  output$game_status <- renderText({
    if (is.null(game$deck)) return("Click 'New Game' to start!")
    
    dealer_value <- hand_value(game$dealer_hand)
    player_value <- hand_value(game$player_hand)
    status <- paste0(
      "Dealer hand value: ", dealer_value, "\n",
      "Player hand value: ", player_value, "\n"
    )
    
    if (game$end_game) {
      if (player_value <= 21 && (dealer_value > 21 || player_value > dealer_value)) {
        status <- paste0(status, "You won!\n")
      } else if ((dealer_value <= 21 && dealer_value > player_value) || player_value > 21) {
        status <- paste0(status, "The dealer won...\n")
      } else {
        status <- paste0(status, "It's a draw.\n")
      }
    }
    return(status)
  })
  
  # Observer les cliques des bouttons
  observeEvent(input$new_game, {
    start_new_game()
  })
  
  observeEvent(input$hit, {
    if (!game$end_game) {
      result <- take_a_card(game$deck, game$player_hand)
      game$deck <- result$pile
      game$player_hand <- result$hand
      
      if (hand_value(game$player_hand) >= 21) {
        game$end_game <- TRUE
      }
    }
  })
  
  observeEvent(input$stand, {
    if (!game$end_game) {
      while (hand_value(game$dealer_hand) < 17) {
        result <- take_a_card(game$deck, game$dealer_hand)
        game$deck <- result$pile
        game$dealer_hand <- result$hand
      }
      game$end_game <- TRUE
    }
  })
}

shinyApp(ui = ui, server = server)

