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


class NoMovesError(Exception):
    """Raised when a player selects one of their pieces to move that is not
    capable of moving to any space on the board

    """
    pass


class NotValidMoveError(Exception):
    """Raised when a player tries to move a piece to a space it is not permitted
    to move to

    """
    pass


class OppPieceError(Exception):
    """Raised when a player selects an opponent's piece"""
    pass