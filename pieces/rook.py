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

        horizontal_moves = []
        for dir in (-1, 1):
            new_col = col + dir
            while new_col in range(8) and board[row][new_col] == 0:
                horizontal_moves.append((row, new_col))
                new_col += dir

        vertical_moves = []
        for dir in (-1, 1):
            new_row = row + dir
            while new_row in range(8) and board[new_row][col] == 0:
                vertical_moves.append((new_row, col))
                new_row += dir
        """horizontal_moves = [(row, new_col) for new_col in range(8) if new_col != col]
        vertical_moves =[(new_row, col) for new_row in range(8) if new_row != row]"""
        return horizontal_moves + vertical_moves