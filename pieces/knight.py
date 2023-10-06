"""
knight.py
Morgan Bauer
Defines an inherited class Knight with methods specific to the mechanics of
knight movement
"""
from pieces.base_piece import BasePiece

class Knight(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'n')


    def valid_moves(self) -> list:
        """Returns a list of all valid moves a selected pawn can make"""
        row = self.space[0]
        col = self.space[1]

        moves = []
        new_rows = [(row + 2, row - 2), (row + 1, row - 1)]
        new_cols = [(col + 1, col - 1), (col + 2, col - 2)]
        for i in range(2):
            for new_col in new_cols[i]:
                if new_col in range(9):
                    for new_row in new_rows[i]:
                        if new_row in range(9):
                            moves.append((new_row, new_col))
        return moves