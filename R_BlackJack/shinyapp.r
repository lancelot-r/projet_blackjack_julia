library(shiny)
library(dplyr)

# Source the game logic files
source("Cartes_et_Deck.R")

# Function to initialize the game
initialize_game <- function() {
  init <- create_blackjack_deck(6) %>% shuffle()
  list(deck = init, player_hand = create_empty_hand(), dealer_hand = create_empty_hand())
}

# Function to generate the file name for the card image
get_card_image <- function(card) {
  paste0(card$rank, "_of_", card$suit, ".png")
}

# Create the Shiny app
ui <- fluidPage(
  titlePanel("Blackjack Game with Images"),
  sidebarLayout(
    sidebarPanel(
      actionButton("new_game", "New Game"),
      actionButton("draw", "Draw"),
      actionButton("fold", "Fold")
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
  
  # Function to start a new game
  start_new_game <- function() {
    init <- initialize_game()
    game$deck <- init$deck
    game$player_hand <- init$player_hand
    game$dealer_hand <- init$dealer_hand
    game$end_game <- FALSE
    
    # Deal initial cards
    game <- deal_initial_cards(game)
  }
  
  # Function to deal initial cards
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
  
  # Function to render the images of cards
  render_hand_images <- function(hand) {
    card_images <- lapply(hand$cards, function(card) {
      img_src <- paste0("https://raw.githubusercontent.com/malnoe/Cours_M1_Remy/main/www/", get_card_image(card))
      tags$img(src = img_src, height = "100px", style = "margin: 5px;")
    })
    do.call(tagList, card_images)
  }
  
  # Display the dealer's hand images
  output$dealer_hand_images <- renderUI({
    if (is.null(game$dealer_hand)) return(NULL)
    render_hand_images(game$dealer_hand)
  })
  
  # Display the player's hand images
  output$player_hand_images <- renderUI({
    if (is.null(game$player_hand)) return(NULL)
    render_hand_images(game$player_hand)
  })
  
  # Display the game status
  output$game_status <- renderText({
    if (is.null(game$deck)) return("Click 'New Game' to start!")
    
    dealer_value <- hand_value(game$dealer_hand)
    player_value <- hand_value(game$player_hand)
    status <- paste0(
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
  
  # Observe button clicks
  observeEvent(input$new_game, {
    start_new_game()
  })
  
  observeEvent(input$draw, {
    if (!game$end_game) {
      result <- take_a_card(game$deck, game$player_hand)
      game$deck <- result$pile
      game$player_hand <- result$hand
      
      if (hand_value(game$player_hand) >= 21) {
        game$end_game <- TRUE
      }
    }
  })
  
  observeEvent(input$fold, {
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

