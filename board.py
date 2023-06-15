from pieces.base_piece import BasePiece
from pieces.pawn import Pawn

class Board:
    def __init__(self) -> None:
        self._state = [[0 for i in range(8)] for j in range(8)]


    def update_state(self, piece) -> None:
        coord_pair = piece.space
        row = coord_pair[0]
        col = coord_pair[1]
        self._state[row][col] = piece


    def __str__(self):
        printed_board = []
        for row in self._state:
            row = [str(space) for space in row]
            printed_board.append(''.join(row))
        return '\n'.join(printed_board)


if __name__ == "__main__":
    my_board = Board()
    print(my_board)