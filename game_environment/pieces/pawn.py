"""
pawn.py
Morgan Bauer
Defines an inherited class Pawn with methods specific to the mechanics of pawn movement
"""
from pieces.base_piece import BasePiece

class Pawn(BasePiece):
    def __init__(self, space: tuple, color: str, player) -> None:
        BasePiece.__init__(self, space, color, 'p', 1, player)
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
        self.__valid_moves.remove(move)


    def set_valid_moves(self, board) -> None:
        """Returns a list of all valid moves a selected pawn can make

        Input:
        board -- a Board object representing the active game board

        """
        row = self.space[0]
        col = self.space[1]

        # Moves pawn one space forward
        moves = []
        new_row = row + (1 * self.direction)

        if new_row in range(8) and board.state[new_row][col] == 0:
            moves.append((new_row, col))

        # Pawns capture diagonally
        for i in [-1, 1]:
            new_col = col + i
            if new_col in range(8) and\
               board.state[new_row][new_col] != 0 and\
               board.state[new_row][new_col].color != self.color:
               moves.append((new_row, new_col))

        # Pawns can move two spaces on their first mov
        if not self.has_moved:
            new_row = row + (2 * self.direction)

            if new_row in range(8) and board.state[new_row][col] == 0 and\
               board.state[new_row - self.direction][col] == 0:
                moves.append((new_row, col))

        self.__valid_moves = moves