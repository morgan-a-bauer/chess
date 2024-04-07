"""
king.py
Morgan Bauer
Defines an inherited class King with methods specific to the mechanics of
king movement
"""
from .base_piece import BasePiece

class King(BasePiece):
    def __init__(self, space: tuple, color: str, player) -> None:
        BasePiece.__init__(self, space, color, 'k', 100, player)
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


    def castle_spaces(self, board) -> list:
        """Returns a list of all spaces a king is able to move to by castling.
        Returns the empty list if none exist

        Input:
        board -- a Board object representing the active game board

        """
        row = self.space[0]
        col = self.space[1]

        castle_spaces = []

        # If the king has moved
        if self.__has_moved:
            return castle_spaces

        # Check conditions for one rook
        if int(board.state[row][0]) == 5:

            # If the rook has not moved
            if not board.state[row][0].has_moved:

                # If there are no pieces between the king and the rook
                if sum([int(space) for space in board.state[row][1:col]]) == 0:
                    castle_spaces.append((row, col - 2))

        # Check conditions for the other rook
        if int(board.state[row][-1]) == 5:

            # If the rook has not moved
            if not board.state[row][-1].has_moved:

                # If there are no pieces between the king and the rook
                if sum([int(space) for space in board.state[row][col + 1: -1]]) == 0:
                    castle_spaces.append((row, col + 2))

        return castle_spaces


    def toss_move(self, move: tuple) -> None:
        """Removes a potential move from the piece's list of valid moves. This
        is used if that move would leave the player's king in check

        Input:
        move -- a tuple of the form (row, col) representing the move to be
                invalidated in grid notation

        """
        self.__valid_moves.remove(move)


    def set_valid_moves(self, board) -> None:
        """Returns a list of all valid moves a selected king can make

        Input:
        board -- a Board object representing the active game board

        """
        row = self.space[0]
        col = self.space[1]

        moves = []

        # Checks symmetrical moves (horizontal, vertical, and diagonal)
        for i in (-1, 1):
            new_row = row + i

            # Vertical moves
            if new_row in range(8) and (board.state[new_row][col] == 0 or\
                                        board.state[new_row][col].color !=\
                                        self.color):
                moves.append((new_row, col))

            new_col = col + i

            # Horizontal moves
            if new_col in range(8) and (board.state[row][new_col] == 0 or\
                                        board.state[row][new_col].color !=\
                                        self.color):
                moves.append((row, new_col))

            # Diagonal moves
            if new_row in range(8) and new_col in range(8) and\
               (board.state[new_row][new_col] == 0 or\
                board.state[new_row][new_col].color != self.color):
                moves.append((new_row, new_col))

            new_col = col - i

            # Diagonal moves along the other diagonal
            if new_row in range(8) and new_col in range(8) and\
               (board.state[new_row][new_col] == 0 or\
                board.state[new_row][new_col].color != self.color):
                moves.append((new_row, new_col))

        self.__valid_moves = moves + self.castle_spaces(board)