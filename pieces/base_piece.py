class BasePiece:
    def __init__(self, space: tuple) -> None:
        self._chr = 'p'
        self._color = ''
        self._space = space


    def __str__(self) -> str:
        return self._chr


    def get_color(self) -> str:
        return self._color
    

    def set_color(self, color: str) -> None:
        self._color = color
    

    def get_space(self) -> tuple:
        return self._space
    

    def set_space(self, new_space: tuple) -> None:
        self._space = new_space