"""
player.py
Morgan Bauer
Defines an class Player to keep track of attributes for each player in the game
"""
from pieces.base_piece import BasePiece


class Player:
    def __init__(self, name: str) -> None:
        self._name = name
        self._uncaptured_pieces = []
        self._score = 0
        self._color = ''


    @property
    def color(self) -> str:
        return self._color


    @color.setter
    def color(self, clr: str) -> None:
        self._color = clr


    @property
    def score(self) -> int:
        return self._score


    @score.setter
    def score(self, val: int) -> None:
        self._score += val


    @property
    def name(self) -> str:
        return self._name


    def lose_piece(self, piece) -> None:
        """Removes a piece from the player's collection of active pieces
        when it is captured by the opposing player
        Inputs:
            piece -- the piece object that was captured
        """
        self._uncaptured_pieces.remove(piece)


    def gain_piece(self, piece) -> None:
        """Adds a piece to the player's collection of active pieces
        when it is gained(i.e. at the start of the game or upon
        promoting a pawn
        Inputs:
            piece -- the piece object that was aquired
        """
        self._uncaptured_pieces.append(piece)