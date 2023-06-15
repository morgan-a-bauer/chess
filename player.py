from pieces.base_piece import BasePiece
from pieces.pawn import Pawn

class Player:
    def __init__(self, color: str) -> None:
        self._uncaptured_pieces = []
        self._score = 0
        self._color = color
    

    @property
    def color(self) -> str:
        return self._color
    

    @property
    def score(self) -> int:
        return self._score
    

    @score.setter
    def score(self, val: int) -> None:
        self._score += val


    def lose_piece(self, piece) -> None:
        self._uncaptured_pieces.remove(piece)


    def gain_piece(self, piece) -> None:
        self._uncaptured_pieces.append(piece)
