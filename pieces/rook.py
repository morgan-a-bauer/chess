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
        self.__valid_moves = []


    @property
    def has_moved(self) -> bool:
        return self.__has_moved


    @has_moved.setter
    def has_moved(self, new_state: bool) -> None:
        self.__has_moved = new_state

    @property
    def valid_moves(self) -> list:
        return self.__valid_moves


    def set_valid_moves(self, board):
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

            if new_col in range(8) and board.state[row][new_col] != 0 and\
               board.state[row][new_col].color != self.color:
                horizontal_moves.append((row, new_col))

        vertical_moves = []

        for dir in (-1, 1):
            new_row = row + dir

            while new_row in range(8) and board.state[new_row][col] == 0:
                vertical_moves.append((new_row, col))
                new_row += dir

            if new_row in range(8) and board.state[new_row][col] != 0 and\
               board.state[new_row][col].color != self.color:
                vertical_moves.append((new_row, col))

        self.__valid_moves =horizontal_moves + vertical_moves