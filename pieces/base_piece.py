"""
base_piece.py
Morgan Bauer
Defines a class BasePiece containing methods common among all piece types in
chess. Other piece classes inherit from BasePiece
"""

class BasePiece:
    def __init__(self, space: tuple, color: str, chr: str, val: float) -> None:
        self.__chr = chr
        self.__color = color
        self.__space = space
        self.__is_captured = False
        self.__val = val


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
    def checking_king(self) -> bool:
        return self.__checking_king


    @checking_king.setter
    def checking_king(self, checking: bool) -> None:
        self.__checking_king = checking


    def __str__(self):
        return self.__chr


    def __int__(self):
        return self.__val