"""
pawn.py
Morgan Bauer
Defines an inherited class Bishop with methods specific to the mechanics of
bishop movement
"""
from .base_piece import BasePiece

class Bishop(BasePiece):
    def __init__(self, space: tuple, color: str, player) -> None:
        BasePiece.__init__(self, space, color, 'b', 3, player)
        self.__valid_moves = []


    @property
    def valid_moves(self) -> list:
        return self.__valid_moves


    def toss_move(self, move: tuple) -> None:
        self.__valid_moves.remove(move)


    def set_valid_moves(self, board) -> None:
        """Returns a list of all valid moves a selected bishop can make"""
        row = self.space[0]
        col = self.space[1]

        moves = []

        # Each direction represents a different diagonal segment
        directions = ((1, 1), (-1, 1), (-1, -1), (1, -1))
        for dir in directions:
            row_dir = dir[0]
            col_dir = dir[1]

            # Calculate new space on diagonal
            new_row = row + row_dir
            new_col = col + col_dir

            # Only check spaces on the board
            while new_row in range(8) and new_col in range(8):

                # If the space is not empty
                if board.state[new_row][new_col] != 0:

                    # If the space contains an opponent's piece, it can be captured
                    if board.state[new_row][new_col].color != self.color:
                        moves.append((new_row, new_col))

                    break

                # Include this move in the list of valid moves
                moves.append((new_row, new_col))
                new_row += row_dir
                new_col += col_dir

        self.__valid_moves = moves