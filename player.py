from pieces.base_piece import BasePiece
from pieces.pawn import Pawn

class Player:
    def __init__(self) -> None:
        self._uncaptured_pieces = []
        self._score = 0
        self._color = ""
    

    def get_color(self) -> str:
        return self._color
    

    def get_score(self) -> int:
        return self._score
    

    def update_score(self, val: int) -> None:
        self._score += val


    def lose_piece(self, piece) -> None:
        self._uncaptured_pieces.remove(piece)


    def gain_piece(self, piece) -> None:
        self._uncaptured_pieces.append(piece)
