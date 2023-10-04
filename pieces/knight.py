"""
knight.py
Morgan Bauer
Defines an inherited class Knight with methods specific to the mechanics of
knight movement
"""
from pieces.base_piece import BasePiece

class Knight(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'n')