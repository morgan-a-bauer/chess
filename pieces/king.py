"""
king.py
Morgan Bauer
Defines an inherited class King with methods specific to the mechanics of
king movement
"""
from pieces.base_piece import BasePiece

class King(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'k', 0)
        self.__has_moved = False

    @property
    def has_moved(self) -> bool:
        return self.__has_moved

    @has_moved.setter
    def has_moved(self, new_state: bool) -> None:
        self.__has_moved = new_state

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

    def valid_moves(self, board) -> list:
        """Returns a list of all valid moves a selected king can make

        Input:
        board -- a Board object representing the active game board

        """
        row = self.space[0]
        col = self.space[1]

        moves = []

        for i in (-1, 1):
            new_row = row + i

            if new_row in range(8) and board.state[new_row][col] == 0:
                moves.append((new_row, col))

            new_col = col + i

            if new_col in range(8) and board.state[row][new_col] == 0:
                moves.append((row, new_col))

            if new_row in range(8) and new_col in range(8) and\
               board.state[new_row][new_col] == 0:
                moves.append((new_row, new_col))

            new_col = col - i

            if new_row in range(8) and new_col in range(8) and\
               board.state[new_row][new_col] == 0:
                moves.append((new_row, new_col))

        return moves + self.castle_spaces(board)
