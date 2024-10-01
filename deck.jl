# On appelle le fichier carte.jl
include("carte.jl")

# On crée une structure mutable de deck qui est composée de cartes (vecteur de Carte)
mutable struct Deck
    cartes::Vector{Carte}
end

function affiche_cartes(d::Deck)
    liste_cartes = d.cartes
    for carte in liste_cartes
        println(valeur(carte))
    end
end

function concatene_decks(decks::Vector{Deck})
    new_list_cards = []
    for deck in decks
        for carte in deck.cartes
            push!(new_list_cards,carte)
        end
    end
    return Deck(new_list_cards)
end

suits = ["clubs","spades","hearts","diamonds"]
ranks = ["ace","2","3","4","5","6","7","8","9","10","jack","queen","king"]


function create_deck_52()
    liste_cartes = []
    for suit in suits
        for rank in ranks
            #image_path = "images/$(rank)_of_$(suit).png"
            push!(liste_cartes, Carte(suit,rank))
        end
    end
    return Deck(liste_cartes)
end

jeu1 = create_deck_52()
affiche_cartes(jeu1)
jeu2 = create_deck_52()
jeu3 = concatene_decks([jeu1,jeu2])
affiche_cartes(jeu3)

function create_blackjack_deck(num_decks=6)
    
end

blackjack_deck = create_blackjack_deck()

play_deck = shuffle!(blackjack_deck)

for card in play_deck[1:10]
    println(card[1], " de ", card[2], " - Valeur: ", card[3])
    image = load(card[4])
    display(image)
end

# Test de Gary

carte_ex1 = Carte("hearts","king")
carte_ex2 = Carte("spades","jack")

println(valeur(carte_ex1))
println(valeur(carte_ex2))

deck1 = deck([carte_ex1,carte_ex2])
affiche_cartes(deck1)