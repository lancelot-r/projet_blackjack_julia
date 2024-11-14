
dico_card_value = {
    "ace" : 1,
    "2" : 2,
    "3" : 3,
    "4" : 4,
    "5" : 5,
    "6" : 6,
    "7" : 7,
    "8" : 8,
    "9" : 9,
    "10" : 10,
    "jack" : 10,
    "queen" : 10,
    "king" : 10
}

class Card:
  def __init__(self, suit, rank):
    self.suit = suit
    self.rank = rank

def card_value(card):
    return dico_card_value[card.rank]

