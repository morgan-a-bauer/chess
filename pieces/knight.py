"""
knight.py
Morgan Bauer
Defines an inherited class Knight with methods specific to the mechanics of
knight movement
"""
from pieces.base_piece import BasePiece

class Knight(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'n', 3)


    def valid_moves(self, board) -> list:
        """Returns a list of all valid moves a selected knight can make

        Input:
        board -- a Board object representing the active game board

        """
        row = self.space[0]
        col = self.space[1]

        moves = []

        new_rows = [(row + 2, row - 2), (row + 1, row - 1)]
        new_cols = [(col + 1, col - 1), (col + 2, col - 2)]

        for i in range(2):
            for new_col in new_cols[i]:
                if new_col in range(8):

                    for new_row in new_rows[i]:
                        if new_row in range(8) and\
                           board.state[new_row][new_col] == 0:
                            moves.append((new_row, new_col))

        return moves