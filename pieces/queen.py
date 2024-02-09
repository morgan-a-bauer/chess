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
        directions = ((1, 1), (-1, 1), (-1, -1), (1, -1))

        for dir in directions:
            row_dir = dir[0]
            col_dir = dir[1]
            new_row = row + row_dir
            new_col = col + col_dir

            while new_row in range(8) and new_col in range(8):

                if board[new_row][new_col] != 0:
                    break

                diag_moves.append((new_row, new_col))
                new_row += row_dir
                new_col += col_dir

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

        return horizontal_moves + vertical_moves + diag_moves