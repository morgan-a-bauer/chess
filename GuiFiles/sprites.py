import pygame
from .GenericScreenElement import GenericScreenElement
from .constants import *
from pieces import *

class Board(GenericScreenElement):
    def __init__(self,container,**kwargs):
        super(Board, self).__init__(parent=container,**kwargs)
        self._img = pygame.image.load(os.path.join(SPRITE_FOLDER_PATH, BOARD_SPRITE)).convert_alpha()
        self._img.set_alpha(128)

        self.surf = pygame.transform.scale(self._img, [*self.size])
        self.surf.set_colorkey((255,255,255), RLEACCEL)
        self.rect = self.surf.get_rect()


class Shape(GenericScreenElement):
    def __init__(self, container, colour, **kwargs):
        super(Shape, self).__init__(parent=container,**kwargs)
        self.surf = pygame.Surface([*self.size])
        self.surf.fill(colour)
        self.rect = self.surf.get_rect()
        

class Piece(GenericScreenElement):
    def __init__(self, container, colour, piece, **kwargs):
        super(Piece, self).__init__(parent=container,**kwargs)
        self._img   = pygame.image.load(f"{WHITE_PIECE if colour else BLACK_PIECE}-{piece}.png").convert_alpha()
        
        self.surf   = pygame.transform.scale(self._img, [*self.size])
        self.surf.set_colorkey((255,255,255), RLEACCEL)
        self.rect   = self.surf.get_rect()
        self.colour = colour
        # self.piece  = 

        

    def onclick(self):
        pass
        
    

