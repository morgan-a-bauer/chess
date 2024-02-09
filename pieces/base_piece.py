"""
base_piece.py
Morgan Bauer
Defines a class BasePiece containing methods common among all piece types in
chess. Other piece classes inherit from BasePiece
"""

class BasePiece:
    def __init__(self, space: tuple, color: str, chr: str) -> None:
        self._chr = chr
        self._color = color
        self._space = space
        self._is_captured = False

    @property
    def color(self) -> str:
        return self._color

    @color.setter
    def color(self, color: str) -> None:
        self._color = color

    @property
    def space(self) -> tuple:
        return self._space

    @space.setter
    def space(self, new_space: tuple) -> None:
        self._space = new_space

    @property
    def direction(self) -> int:
        if self.color == 'white':
            return 1

        elif self.color == 'black':
            return -1

    def __str__(self):
        return self._chr