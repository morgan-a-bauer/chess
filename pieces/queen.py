"""
queen.py
Morgan Bauer
Defines an inherited class Queen with methods specific to the mechanics of
queen movement
"""
from pieces.base_piece import BasePiece

class Queen(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'q')


    def valid_moves(self, board):
        """Returns a list of all valid moves a selected queen can make"""
        row = self.space[0]
        col = self.space[1]

        diag_moves = []
        for new_col in range(8):
            if new_col != col:
                diff = abs(new_col - col)
                for gap in (diff, -diff):
                    new_row = row + gap
                    if new_row in range(8):
                        diag_moves.append((new_row , new_col))
        horizontal_moves = [(row, new_col) for new_col in range(8) if new_col != col]
        vertical_moves =[(new_row, col) for new_row in range(8) if new_row != row]
        return horizontal_moves + vertical_moves + diag_moves