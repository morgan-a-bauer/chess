"""
chess_errors.py
Morgan Bauer
Because normal errors just aren't cutting it
"""


class ANError(Exception):
    """Raised when there is an error with algebraic notation entered"""
    pass


class InCheckError(Exception):
    """Raised when a player is in check and tries to move a piece that does now
    get the player out of check

    """
    pass


class NoPieceError(Exception):
    """Raised when a player selects a space with no piece"""
    pass


class OppPieceError(Exception):
    """Raised when a player selects an opponent's piece"""
    pass