import os
import pygame
from GenericScreenElement import GenericScreenElement
from Constants import *


class Board(GenericScreenElement, pygame.sprite.Sprite):
    def __init__(self):
        super(Board, self).__init__()
        self._img = pygame.image.load(os.path.join(os.path.abspath("GuiFiles"),"sprites/Chess_board.png")).convert_alpha()

        self.surf = pygame.transform.scale(self._img, [*self.size])
        self.surf.set_colorkey((255,255,255), RLEACCEL)
        self.rect = self.surf.get_rect()

    

