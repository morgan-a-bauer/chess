"""
rook.py
Morgan Bauer
Defines an inherited class Rook with methods specific to the mechanics of
rook movement
"""
from pieces.base_piece import BasePiece

class Rook(BasePiece):
    def __init__(self, space: tuple, color: str, player) -> None:
        BasePiece.__init__(self, space, color, 'r', 5, player)
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


    def toss_move(self, move: tuple) -> None:
        """Removes a potential move from the piece's list of valid moves. This
        is used if that move would leave the player's king in check

        Input:
        move -- a tuple of the form (row, col) representing the move to be
                invalidated in grid notation

        """
        self.__valid_moves.remove(move)


    def set_valid_moves(self, board) -> None:
        """Returns a list of all valid moves a selected bishop can make

        Input:
        board -- a Board object representing the active game board

        """
        row = self.space[0]
        col = self.space[1]

        # Check horizontal moves
        horizontal_moves = []

        for dir in (-1, 1):
            new_col = col + dir

            # If the space is on the board and is empty
            while new_col in range(8) and board.state[row][new_col] == 0:
                horizontal_moves.append((row, new_col))
                new_col += dir

            # If the piece occupying the space belongs to the opposing player,
            # it can be captured
            if new_col in range(8) and board.state[row][new_col] != 0 and\
               board.state[row][new_col].color != self.color:
                horizontal_moves.append((row, new_col))

        # Check vertical moves
        vertical_moves = []

        for dir in (-1, 1):
            new_row = row + dir

            # If the space is on the board and is empty
            while new_row in range(8) and board.state[new_row][col] == 0:
                vertical_moves.append((new_row, col))
                new_row += dir

            # If the piece occupying the space belongs to the opposing player,
            # it can be captured
            if new_row in range(8) and board.state[new_row][col] != 0 and\
               board.state[new_row][col].color != self.color:
                vertical_moves.append((new_row, col))

        # Combine horizontal and vertical moves
        moves = horizontal_moves + vertical_moves

        self.__valid_moves = moves