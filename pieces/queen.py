"""
queen.py
Morgan Bauer
Defines an inherited class Queen with methods specific to the mechanics of
queen movement
"""
from pieces.base_piece import BasePiece

class Queen(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'q')