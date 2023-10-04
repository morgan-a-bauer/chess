"""
rook.py
Morgan Bauer
Defines an inherited class Rook with methods specific to the mechanics of
rook movement
"""
from pieces.base_piece import BasePiece

class Rook(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'r')