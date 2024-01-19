"""
pawn.py
Morgan Bauer
Defines an inherited class Pawn with methods specific to the mechanics of pawn movement
"""
from pieces.base_piece import BasePiece

class Pawn(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'p')
        self._has_moved = False


    @property
    def has_moved(self) -> bool:
        return self._has_moved


    @has_moved.setter
    def has_moved(self, new_state: bool) -> None:
        self._has_moved = new_state


    def valid_moves(self, board) -> list:
        """Returns a list of all valid moves a selected pawn can make"""
        row = self.space[0]
        col = self.space[1]

        moves = []
        new_row = row + (1 * self.direction)
        if new_row in range(8) and board[new_row][col] == 0:
            moves.append((new_row, col))

        if not self.has_moved:
            new_row = row + (2 * self.direction)
            if new_row in range(8) and board[new_row][col] == 0:
                moves.append((new_row, col))

        return moves