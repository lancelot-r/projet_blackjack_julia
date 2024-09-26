@oodef mutable struct carte
    nom::String
    suit::String
    valeur::Int
    
    function new(nom::String,suit::String, valeur::Int)
        self = @mk
        self.nom = nom
        self.suit = suit
        self.valeur = valeur
        return self
    end

    function renvoie_valeur(self)
        print(self.valeur)
    end
end

carte_ex = carte("Deux",2)
carte.renvoie_valeur()

