"""
board.py
Morgan Bauer
Defines a class Board to keep track of the state of the active game board
"""
from pieces.base_piece import BasePiece
from pieces.pawn import Pawn

class Board:
    def __init__(self) -> None:
        self.__state = [[0 for i in range(8)] for j in range(8)]


    @property
    def state(self) -> list:
        return self.__state


    def remove_piece(self, piece: BasePiece) -> None:
        """
        Sets the space on the board where a piece used to be equal to 0 when
        the piece is moved or captured

        Input:
        piece -- the piece object that is being removed

        """
        row = piece.space[0]
        col = piece.space[1]
        self.__state[row][col] = 0


    def place_piece(self, piece: BasePiece, new_row: int, new_col: int) -> None:
        """
        Updates the state of the game board whenever a piece is added or moved

        Input:
        piece -- the piece object whose state is modified
        new_row -- the row the piece is being moved to
        new_col -- the column the piece is being moved to

        """
        self.__state[new_row][new_col] = piece
        piece.space = (new_row, new_col)


    def __str__(self):
        printed_board = []
        printed_board.append('  abcdefgh  ')

        for row_num, row in enumerate(self.state):
            new_row = [str(8 - row_num)]
            new_row.append(' ')
            new_row += [str(space) for space in row]
            new_row.append(' ')
            new_row.append(str(8 - row_num))
            printed_board.append(''.join(new_row))

        printed_board.append('  abcdefgh  ')

        return '\n'.join(printed_board)



if __name__ == "__main__":
    my_board = Board()
    print(my_board)