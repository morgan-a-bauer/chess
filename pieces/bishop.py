"""
pawn.py
Morgan Bauer
Defines an inherited class Bishop with methods specific to the mechanics of
bishop movement
"""
from pieces.base_piece import BasePiece

class Bishop(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'b', 3)


    def valid_moves(self, board) -> list:
        """Returns a list of all valid moves a selected bishop can make"""
        row = self.space[0]
        col = self.space[1]

        moves = []
        directions = ((1, 1), (-1, 1), (-1, -1), (1, -1))
        for dir in directions:
            row_dir = dir[0]
            col_dir = dir[1]
            new_row = row + row_dir
            new_col = col + col_dir

            while new_row in range(8) and new_col in range(8):
                if board[new_row][new_col] != 0:

                    if board.state[new_row][new_col].color != self.color:
                        moves.append((new_row, new_col))

                    break

                moves.append((new_row, new_col))
                new_row += row_dir
                new_col += col_dir

        return moves