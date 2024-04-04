"""
knight.py
Morgan Bauer
Defines an inherited class Knight with methods specific to the mechanics of
knight movement
"""
from pieces.base_piece import BasePiece

class Knight(BasePiece):
    def __init__(self, space: tuple, color: str, player) -> None:
        BasePiece.__init__(self, space, color, 'n', 3, player)
        self.__valid_moves = []

    @property
    def valid_moves(self) -> list:
        return self.__valid_moves


    def toss_move(self, move: tuple) -> None:
        self.__valid_moves.remove(move)


    def set_valid_moves(self, board) -> None:
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
                           (board.state[new_row][new_col] == 0 or\
                            board.state[new_row][new_col].color != self.color):
                            moves.append((new_row, new_col))

        self.__valid_moves = moves