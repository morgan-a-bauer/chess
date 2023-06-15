class BasePiece:
    def __init__(self, space: tuple, color: str) -> None:
        self._chr = 'p'
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

    
    def __str__(self):
        return self._chr