using Random
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

