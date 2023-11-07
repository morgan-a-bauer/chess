"""
pawn.py
Morgan Bauer
Defines an inherited class Bishop with methods specific to the mechanics of
bishop movement
"""
from pieces.base_piece import BasePiece

class Bishop(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'b')


    def valid_moves(self) -> list:
        """Returns a list of all valid moves a selected pawn can make"""
        row = self.space[0]
        col = self.space[1]

        moves = []
        for new_col in range(8):
            if new_col != col:
                diff = abs(new_col - col)
                for gap in (diff, -diff):
                    new_row = row + gap
                    if new_row in range(8):
                        moves.append((new_row , new_col))
        return moves