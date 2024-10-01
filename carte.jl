using Random
using Images

suits = ["clubs","spades","hearts","diamonds"]
ranks = ["ace","2","3","4","5","6","7","8","9","10","jack","queen","king"]

dico_card_value = Dict(
    "ace" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "jack" => 10,
    "queen" => 10,
    "king" => 10
)

function create_deck()
    deck = []
    for suit in suits
        for rank in ranks
            image_path = "images/$(rank)_of_$(suit).png"
            push!(deck, (rank, suit, card_value[rank], image_path))
        end
    end
    return deck
end

function create_blackjack_deck(num_decks=6)
    full_deck = []
    for _ in 1:num_decks
        append!(full_deck, create_deck())
    end
    return full_deck
end

blackjack_deck = create_blackjack_deck()

play_deck = shuffle!(blackjack_deck)

for card in play_deck[1:10]
    println(card[1], " de ", card[2], " - Valeur: ", card[3])
    image = load(card[4])
    display(image)
end

#Old code
struct Carte
    suit::String
    rank::String
end

function valeur(c::Carte)
    return dico_card_value[c.rank]
end

carte_ex = Carte("hearts","king")
print(valeur(carte_ex))