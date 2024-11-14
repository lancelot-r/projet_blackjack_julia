import random
from carte import Card, dico_card_value, card_value

class Deck:
    def __init__(self, cards):
        self.cards = cards

def print_deck_values(d):
    for card in d.cards :
        print(str(card_value(card))+" ")

#print_deck_values(Deck([Card("hearts","ace"),Card("spades","king")]))

# Creation d'un jeu de 52 cartes
suits = ["clubs","spades","hearts","diamonds"]
ranks = ["ace","2","3","4","5","6","7","8","9","10","jack","queen","king"]

def create_deck_52():
    cards_list = []
    for suit in suits :
        for rank in ranks:
            cards_list.append(Card(suit,rank))
    return Deck(cards_list)

#print_deck_values(create_deck_52())

# Fonction de concaténation de decks
def concat_decks(decks):
    cards_list = decks[0].cards
    for i in range(1,len(decks)):
        cards_list = cards_list + decks[i].cards
    return Deck(cards_list)


# Fonction de création d'un jeu de blackjack
def create_blackjack(number=6):
    deck_52 = create_deck_52()
    list_decks = [deck_52]
    for _ in range(1,number):
        list_decks.append(deck_52)
    return concat_decks(list_decks)

blackjack_deck = create_blackjack()

# Mélanger les cartes d'une main
def shuffle(d):
    # Attention, modifie le deck !
    random.shuffle(d.cards)

# Créer une main vide
def create_empty_hand():
    return Deck([])

# Fonction de calcul de la valeur d'une main
def hand_value(d):
    value = 0
    aces = 0
    for card in d.cards:
        rank = card.rank
        if rank == "ace":
            aces +=1
            value +=11
        else:
            value += dico_card_value[rank]
    
    while(value>21 and aces > 0):
        value -=10
        aces -=1

    return value

# Fonction take_a_card
def take_a_card(pile,hand):
    new_card = pile.cards.pop(0) #Premier element
    hand.cards.append(new_card)
    return


# Fonction display_hand
def display_hand(hand,name):
    print("The " + name + " hand : ")
    for card in hand.cards :
        print(card.rank + " of " + card.suit + ", ")
    print("")

