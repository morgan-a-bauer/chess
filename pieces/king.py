"""
king.py
Morgan Bauer
Defines an inherited class King with methods specific to the mechanics of
king movement
"""
from pieces.base_piece import BasePiece

class King(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'k')
        self._has_moved = False

    @property
    def has_moved(self) -> bool:
        return self._has_moved

    @has_moved.setter
    def has_moved(self, new_state: bool) -> None:
        self._has_moved = new_state

    def valid_moves(self, board):
        """Returns a list of all valid moves a selected king can make"""
        row = self.space[0]
        col = self.space[1]

        moves = []

        for i in (-1, 1):
            new_row = row + i

            if new_row in range(8) and board[new_row][col] == 0:
                moves.append((new_row, col))

            new_col = col + i

            if new_col in range(8) and board[row][new_col] == 0:
                moves.append((row, new_col))

            if new_row in range(8) and new_col in range(8) and board[new_row][new_col] == 0:
                moves.append((new_row, new_col))

            new_col = col - i

            if new_row in range(8) and new_col in range(8) and board[new_row][new_col] == 0:
                moves.append((new_row, new_col))

        return moves
