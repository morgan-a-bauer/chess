"""
base_piece.py
Morgan Bauer
Defines a class BasePiece containing methods common among all piece types in
chess. Other piece classes inherit from BasePiece
"""
from copy import deepcopy

class BasePiece:
    def __init__(self, space: tuple, color: str, chr: str, val: float,
                 player) -> None:
        self.__chr = chr
        self.__color = color
        self.__space = space
        self.__is_captured = False
        self.__val = val
        self.__player = player


    @property
    def color(self) -> str:
        return self.__color


    @color.setter
    def color(self, color: str) -> None:
        self.__color = color


    @property
    def space(self) -> tuple:
        return self.__space


    @space.setter
    def space(self, new_space: tuple) -> None:
        self.__space = new_space
        self.__checking_king = False


    @property
    def direction(self) -> int:
        """returns the multiplicative identity if the player is white, otherwise
        returns its negative. This value is used as a scalar for movement of
        pawns

        """
        if self.__color == 'white':
            return 1

        elif self.__color == 'black':
            return -1


    @property
    def player(self):
        return self.__player


    @player.setter
    def player(self, new_player) -> None:
        self.__player = new_player


    def remove_in_check_moves(self, board, opponent) -> None:
        vm_copy = deepcopy(self.valid_moves)
        for move in vm_copy:
            row, col = self.space
            opp_piece = board.state[move[0]][move[1]]
            board.remove_piece(self)
            board.place_piece(self, move[0], move[1])

            opponent.get_valid_moves(board)

            for piece in opponent.uncaptured_pieces:

                if self.player.king.space in piece.valid_moves:
                    self.toss_move(move)

            board.remove_piece(self)
            board.place_piece(self, row, col)

            if opp_piece != 0:
                board.place_piece(opp_piece, move[0], move[1])


    def __str__(self):
        return self.__chr


    def __int__(self):
        return self.__val