import pygame
from .GenericScreenElement import GenericScreenElement
from .constants import *
from board import Board as board
# from pieces import *

class BoardSprite(GenericScreenElement):
    def __init__(self,container,**kwargs):
        super(BoardSprite, self).__init__(parent=container,**kwargs)
        self._img = pygame.image.load(os.path.join(SPRITE_FOLDER_PATH, BOARD_SPRITE)).convert_alpha()
        self._img.set_alpha(128)

        self.surf = pygame.transform.scale(self._img, [*self.size])
        self.surf.set_colorkey((255,255,255), RLEACCEL)
        self.rect = self.surf.get_rect()

        self.container = board()


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

        exec(f"from pieces.{piece} import *")
        exec(f'self.piece = {piece.title()}(({row},{col}),{white if color else black}, player)')
        container.container.place_piece(self.piece, row, col)
        player.gain_piece(self.piece)

        
    def onclick(self):
        pass
        

    

