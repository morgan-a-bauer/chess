"""
rook.py
Morgan Bauer
Defines an inherited class Rook with methods specific to the mechanics of
rook movement
"""
from pieces.base_piece import BasePiece

class Rook(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'r')

    def valid_moves(self, board):
        """Returns a list of all valid moves a selected bishop can make"""
        row = self.space[0]
        col = self.space[1]

        horizontal_moves = [(row, new_col) for new_col in range(8) if new_col != col]
        vertical_moves =[(new_row, col) for new_row in range(8) if new_row != row]
        return horizontal_moves + vertical_moves