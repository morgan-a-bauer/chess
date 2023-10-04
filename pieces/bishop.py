"""
pawn.py
Morgan Bauer
Defines an inherited class Bishop with methods specific to the mechanics of
bishop movement
"""
from pieces.base_piece import BasePiece

class Bishop(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'b')