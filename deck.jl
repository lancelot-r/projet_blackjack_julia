module DeckDefinitions
# On appelle le fichier carte.jl
include("carte.jl")
using .CardDefinitions
using Random
import Random.shuffle!


# On crée une structure mutable de deck qui est composée de cartes (vecteur de Carte)
mutable struct Deck
    cartes::Vector{CardDefinitions.Carte}
end


# Fonction de test pour afficher la valeur (numerique) des cartes d'un deck.
function affiche_valeur_cartes(d::Deck)
    liste_cartes = d.cartes
    for carte in liste_cartes
        println(valeur(carte))
    end
end

function create_deck_52()
    liste_cartes = Vector{CardDefinitions.Carte}()
end

# Creation d'un jeu de 52 cartes
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
    return DeckDefinitions.Deck(liste_cartes)
end

# Fonction de concatenation de decks
function concatene_decks(decks::Vector{Deck})
    new_list_cards = Vector{CardDefinitions.Carte}()
    for deck in decks
        for carte in deck.cartes
            push!(new_list_cards,carte)
        end
    end

    return DeckDefinitions.Deck(new_list_cards)
end

jeu1 = create_deck_52()
length(jeu1.cartes)
jeuc = concatene_decks([jeu1,jeu1])
length(jeuc.cartes)


# Fonction de creation d'un jeu de blackjack
# Amelioration : + rapide de faire une version modifiée de creation_deck_52 plutôt que de l'appeler ?
function create_blackjack_deck(num_decks)
    # On récupère un deck de 52 cartes.
    deck_52 = create_deck_52()

    # On crée une liste où on va mettre num_decks decks de 52 cartes pour les concatener.
    vect_deck_52 = [deck_52]
    for i in range(1,num_decks-1)
        append!(vect_deck_52,[deck_52])
    end
    res = concatene_decks(vect_deck_52)
    return res
end

blackjack_deck = create_blackjack_deck(6)

# Fonction pour melanger un deck un modifiant l'objet
# On surcharge / etend la fonction shuffle deja existante.
# Moins couteux en memoire vu qu'on modifie juste un objet déjà existant mais du coup on perd le jeu de base.
function shuffle!(deck::Deck) 
    Random.shuffle!(deck.cartes) 
    return
end

# Fonction pour creer un nouveau deck avec les memes cartes mais melangees
# On surcharge / etend la fonction shuffle! deja existante.
# Plus couteux en memoire vu qu'on aura 2 objects avec les memes cartes mais permet de garder le jeu de base intact.
function shuffle(deck::Deck)
    cards_new_order = Random.shuffle(deck.cartes)
    return DeckDefinitions.Deck(cards_new_order)

end

# /!\ 
#blackjack_deck = create_blackjack_deck(6)
#play_deck = shuffle(blackjack_deck)
# -> blackjack_deck est pas modifie.
# C'est different de :
#blackjack_deck = create_blackjack_deck(6)
#play_deck = shuffle!(blackjack_deck)
# -> blackjeack_deck est modifie.

function create_empty_hand()
    return DeckDefinitions.Deck([])

end


# Fonction de calcul de la valeur d'une main / d'un deck.
function hand_value(hand::Deck)
    value = 0
    aces = 0
#pour donner a chaque carte sa valeur définie
    for card in hand.cartes
        rank = card.rank
        if rank == "ace" #pour le cas spécial ace
            value += 11
            aces += 1
        else
            value += dico_card_value[rank]
        end
    end

    # Ajuster ace quand la main >21
    while value > 21 && aces > 0
        value -= 10
        aces -= 1
    end

    return value
end


function take_a_card(pile::Deck,player_hand::Deck)
    new_card = popfirst!(pile.cartes)
    append!(player_hand.cartes,[new_card])
    return
end

function display_hand(hand::Deck,name::String)
    print("The " * name * " hand : ")
    for card in hand.cartes
        print(card.rank)
        print(" of ")
        print(card.suit)
        print(", ")
    end
    println("")
end

export Deck,take_a_card, display_hand, create_empty_hand, hand_value, shuffle, shuffle!, create_deck_52, affiche_valeur_cartes, concatene_decks, create_blackjack_deck 
end