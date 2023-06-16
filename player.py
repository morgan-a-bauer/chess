from pieces.base_piece import BasePiece
from pieces.pawn import Pawn

class Player:
    def __init__(self, name: str, color: str) -> None:
        self._name = name
        self._uncaptured_pieces = []
        self._score = 0
        self._color = color
    

    @property
    def color(self) -> str:
        return self._color
    

    @property
    def score(self) -> int:
        return self._score
    

    @property
    def name(self) -> str:
        return self._name
    
    
    @score.setter
    def score(self, val: int) -> None:
        self._score += val


    def lose_piece(self, piece) -> None:
        self._uncaptured_pieces.remove(piece)


    def gain_piece(self, piece) -> None:
        self._uncaptured_pieces.append(piece)
