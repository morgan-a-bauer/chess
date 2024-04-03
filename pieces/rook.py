"""
rook.py
Morgan Bauer
Defines an inherited class Rook with methods specific to the mechanics of
rook movement
"""
from pieces.base_piece import BasePiece

class Rook(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'r', 5)
        self.__has_moved = False

    @property
    def has_moved(self) -> bool:
        return self.__has_moved

    @has_moved.setter
    def has_moved(self, new_state: bool) -> None:
        self.__has_moved = new_state

    def valid_moves(self, board):
        """Returns a list of all valid moves a selected bishop can make

        Input:
        board -- a Board object representing the active game board

        """
        row = self.space[0]
        col = self.space[1]

        horizontal_moves = []

        for dir in (-1, 1):
            new_col = col + dir

            while new_col in range(8) and board.state[row][new_col] == 0:
                horizontal_moves.append((row, new_col))
                new_col += dir

        vertical_moves = []

        for dir in (-1, 1):
            new_row = row + dir

            while new_row in range(8) and board.state[new_row][col] == 0:
                vertical_moves.append((new_row, col))
                new_row += dir

        return horizontal_moves + vertical_moves