import pygame
from .generic_element import GenericScreenElement
from .constants import *
from game_environment.board import Board as board
# from pieces import *

class BoardSprite(GenericScreenElement):
    def __init__(self,container,**kwargs):
        super(BoardSprite, self).__init__(parent=container,**kwargs)
        self._img = pygame.image.load(os.path.join(SPRITE_FOLDER_PATH, BOARD_SPRITE)).convert_alpha()
        self._img.set_alpha(128)

        self.surf = pygame.transform.scale(self._img, [*self.size])
        self.surf.set_colorkey((255,255,255), RLEACCEL)
        self.rect = self.surf.get_rect()

        self.matrix    = [[0 for i in range(8)] for j in range(8)]
        self.container = board()

    def remove_piece(self, pieceContainer) -> None:
        """
        Sets the space on the board where a piece used to be equal to 0 when
        the piece is moved or captured

        Input:
        piece -- the piece object that is being removed

        """
        # print(pieceContainer.row, pieceContainer.col)
        self.matrix[pieceContainer.row][pieceContainer.col] = 0
        self.container._state[pieceContainer.row][pieceContainer.col] = 0

    def place_piece(self, pieceContainer, new_row: int, new_col: int) -> None:
        """
        Updates the state of the game board whenever a piece is added or moved

        Input:
        piece -- the piece object whose state is modified
        new_row -- the row the piece is being moved to
        new_col -- the column the piece is being moved to

        """
        self.matrix[new_row][new_col] = pieceContainer
        self.container._state[new_row][new_col] = pieceContainer.piece

        pieceContainer.move(new_row, new_col)
        pieceContainer.piece.space = (new_row, new_col)

    def __str__(self):
        printed_board = []
        printed_board.append('  abcdefgh  ')

        for row_num, row in enumerate(self.matrix):
            new_row = [str(8 - row_num)]
            new_row.append(' ')
            new_row += [str(space) for space in row]
            new_row.append(' ')
            new_row.append(str(8 - row_num))
            printed_board.append(''.join(new_row))

        printed_board.append('  abcdefgh  ')

        return '\n'.join(printed_board)


class Shape(GenericScreenElement):
    def __init__(self, container, color, **kwargs):
        super(Shape, self).__init__(parent=container,**kwargs)
        self.surf = pygame.Surface([*self.size])
        self.surf.fill(color)
        self.rect = self.surf.get_rect()


class Piece(GenericScreenElement):
    def __init__(self, container, player, color, piece, row, col, **kwargs):
        super(Piece, self).__init__(parent=container, row=row, col=col,**kwargs)
        self._img   = pygame.image.load(f"{WHITE_PIECE if color else BLACK_PIECE}-{piece}.png").convert_alpha()
        
        self.surf   = pygame.transform.scale(self._img, [*self.size])
        self.surf.set_colorkey((255,255,255), RLEACCEL)
        self.rect   = self.surf.get_rect()
        self.color = color

        white = 'white'
        black = 'black'

        exec(f"from game_environment.pieces.{piece} import *")
        # print(f"{piece.title()}(({row},{col}),{white if color else black}, {player})")
        exec(f'self.piece = {piece.title()}(({row},{col}),{white if color else black}, player)')
        # print(self.piece)
        container.container.place_piece(self.piece, row, col)
        player.gain_piece(self.piece)
        if piece == 'king':
            player.king = self.piece

    def __str__(self):
        return str(self.piece)
    
    def capture_piece(self, board, row: int, col: int) -> None:
        """When a piece lands on a space containing another piece, that piece
        gets captured
        
        Input:
        """
        # Get opponent's piece
        opp_piece = board.matrix[row][col]


        # Place piece
        board.remove_piece(self)
        board.place_piece(self, row, col)

        # Opponent's piece is removed from their uncaptured pieces and added
        # to the current player's list of captured pieces
        opp_piece.piece.player.uncaptured_pieces.remove(opp_piece.piece)
        self.piece.player.capture(opp_piece.piece)
        opp_piece.kill()

    
        

    

