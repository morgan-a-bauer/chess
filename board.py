"""
board.py
Morgan Bauer
Defines a class Board to keep track of the state of the active game board
"""
from pieces.base_piece import BasePiece
from pieces.pawn import Pawn

class Board:
    def __init__(self) -> None:
        self._state = [[0 for i in range(8)] for j in range(8)]


    @property
    def state(self) -> list:
        return self._state


    def update_state(self, piece: BasePiece) -> None:
        """
        Updates the state of the game board whenever a piece is added,
        removed, or moves position
        Inputs:
            piece -- the piece object whose state is modified
        """
        coord_pair = piece.space
        row = coord_pair[0]
        col = coord_pair[1]
        self._state[row][col] = piece


    def __str__(self):
        printed_board = []
        printed_board.append('  abcdefgh  ')

        for row_num, row in enumerate(self.state):
            new_row = [str(row_num + 1)]
            new_row.append(' ')
            new_row += [str(space) for space in row]
            new_row.append(' ')
            new_row.append(str(row_num + 1))
            printed_board.append(''.join(new_row))

        printed_board.append('  abcdefgh  ')
        return '\n'.join(printed_board)



if __name__ == "__main__":
    my_board = Board()
    print(my_board)