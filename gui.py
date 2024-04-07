from gui_files.sprites import BoardSprite, Shape, Piece
from gui_files.generic_element import GenericScreenElement
from gui_files.constants import *
from game_environment.player import Player
from game_environment.utils import *
import random
import pygame
import math


class Gui():

    def __init__(self, grid:tuple=GRID):
        """
        
        """
        self._screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        self._running = True
        self._rows = grid[0]
        self._cols = grid[1]
        self._container = GenericScreenElement(childGrid=GRID)

        self._allSprites   = pygame.sprite.Group()
        self._pieceSprites = pygame.sprite.Group()
        self._blackSprites = pygame.sprite.Group()
        self._whiteSprites = pygame.sprite.Group()

        self._players = [Player('Jackson'), Player('Morgan')]

        self._spawn_objects()

        self._turn = 1
        self._activePiece = None
        self._targetSquare = None



    @property
    def rows(self):
        return self._rows
    
    
    @property
    def cols(self):
        return self._cols
    

    def _populate_board(self, onTop=0):

        random.shuffle(self._players)

        for color in range(2):
            self._players[color].color = 'white' if color else 'black'

            for pieceIndex in range(len(PIECES)):

                piece = PIECES[pieceIndex]  if not onTop else "queen" if PIECES[pieceIndex] == "king" else "king" if PIECES[pieceIndex] == "queen" else PIECES[pieceIndex] 
                sprite = Piece(self._board,
                               self._players[color],
                                           color=color, 
                                           piece=piece, 
                                           grid=(8,8), 
                                           row=abs((7*(not(color) if onTop else color))-(pieceIndex//(len(PIECES)//2))),
                                           col=pieceIndex%(len(PIECES)//2))
                self._allSprites.add(sprite)
                self._pieceSprites.add(sprite)
                if color:
                    self._whiteSprites.add(sprite)
                else:
                    self._blackSprites.add(sprite)


    def _spawn_objects(self):

        # Board Spawning
        self._boardBackdrop = Shape(self._container, BD_COLOR, childGrid=(1,1), padx=0, pady=0, row=BOARD_ROW, col=BOARD_COL, rowSpan=BOARD_ROW_SPAN, colSpan=BOARD_COL_SPAN)
        self._allSprites.add(self._boardBackdrop)

        self._board = BoardSprite(self._boardBackdrop, childGrid=(8,8), padx=20, pady=20, row=0, col=0)
        self._board.container
        self._allSprites.add(self._board)
        self._populate_board(1)


    def _check_events(self):
        """

        """
        for event in pygame.event.get():

            if event.type == KEYDOWN:

                if event.key == K_ESCAPE:
                    self._running = False

            if event.type == KEYUP:
                pass

            if event.type == MOUSEBUTTONDOWN:

                if event.button == 1:

                    for sprite in self._pieceSprites:

                        if (event.pos[0] in range(sprite.position[0], sprite.coords[0])) and (event.pos[1] in range(sprite.position[1], sprite.coords[1])):
                                
                                print(event)
                                print(sprite.coords)

                                if sprite.color == self._turn:
                                    self._activePiece = sprite
                                


                    

            elif event.type == QUIT:
                self._running = False

            # print(event)


    def _draw(self):
        """

        """
        for sprite in self._allSprites:
            self._screen.blit(sprite.surf, [*sprite.position])


    def _update_display(self):
        """
        
        """ 
        self._screen.fill(BG_COLOR)
        self._draw()
        pygame.display.flip()


    def mainloop(self):
        """

        """
        while self._running:

            self._check_events()
            self._update_display()



if __name__ == '__main__':
    pygame.init()
    run = Gui()
    run.mainloop()
    