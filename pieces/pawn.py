from base_piece import BasePiece

class Pawn(BasePiece):
    def __init__(self, space: tuple) -> None:
        BasePiece.__init__(space)
