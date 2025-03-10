"""
player.py
Morgan Bauer
Defines an class Player to keep track of attributes for each player in the game
"""
from .pieces.base_piece import BasePiece

class Player:
    def __init__(self, name: str) -> None:
        self.__name = name.capitalize()
        self.__uncaptured_pieces = []
        self.__score = 0
        self.__color = ''
        self.__king = None
        self.__captured = []


    @property
    def name(self) -> str:
        return self.__name


    @property
    def uncaptured_pieces(self) -> list:
        return self.__uncaptured_pieces


    @property
    def score(self) -> int:
        return self.__score


    @score.setter
    def score(self, val: int) -> None:
        self.__score += val


    @property
    def color(self) -> str:
        return self.__color


    @color.setter
    def color(self, clr: str) -> None:
        self.__color = clr


    @property
    def king(self):
        return self.__king


    @king.setter
    def king(self, new_king) -> None:
        self.__king = new_king


    @property
    def captured(self) -> list:
        return self.__captured


    def capture(self, piece) -> None:
        """If the player captures an opponent's piece, it gets added to the
        player's list of captured pieces

        """
        self.__captured.append(piece)


    def lose_piece(self, piece) -> None:
        """Removes a piece from the player's collection of active pieces
        when it is captured by the opposing player

        Input:
        piece -- the piece object that was captured

        """
        
        self.__uncaptured_pieces.remove(piece)


    def gain_piece(self, piece) -> None:
        """Adds a piece to the player's collection of active pieces
        when it is gained(i.e. at the start of the game or upon
        promoting a pawn

        Input:
        piece -- the piece object that was aquired

        """
        self.__uncaptured_pieces.append(piece)


    def get_valid_moves(self, board) -> None:
        """Gets valid moves for all of a player's pieces

        Input:
        board -- a Board object representing the active board

        """
        for piece in self.__uncaptured_pieces:
            
            piece.set_valid_moves(board)
