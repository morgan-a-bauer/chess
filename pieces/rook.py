from pieces.base_piece import BasePiece

class Rook(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'r')