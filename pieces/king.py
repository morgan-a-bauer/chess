"""
king.py
Morgan Bauer
Defines an inherited class King with methods specific to the mechanics of
king movement
"""
from pieces.base_piece import BasePiece

class King(BasePiece):
    def __init__(self, space: tuple, color: str) -> None:
        BasePiece.__init__(self, space, color, 'k')