from GuiFiles.sprites import Board, Shape, Piece
from GuiFiles.GenericScreenElement import GenericScreenElement
from GuiFiles.constants import *
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
        self._container = GenericScreenElement(grid=GRID)

        self._allSprites   = pygame.sprite.Group()
        self._pieceSprites = pygame.sprite.Group()
        self._blackSprites = pygame.sprite.Group()
        self._whiteSprites = pygame.sprite.Group()
        self._spawn_objects()

        self._activePiece = None


    @property
    def rows(self):
        return self._rows
    
    
    @property
    def cols(self):
        return self._cols
    

    def _populate_board(self, onTop=0):
        colour = 0
        while colour <= 1:
            for pieceIndex in range(len(PIECES)):

                piece = PIECES[pieceIndex]  if not onTop else "queen" if PIECES[pieceIndex] == "king" else "king" if PIECES[pieceIndex] == "queen" else PIECES[pieceIndex] 
                sprite = Piece(self._board, 
                                           colour=colour, 
                                           piece=piece, 
                                           grid=(8,8), 
                                           row=abs((7*(not(colour) if onTop else colour))-(pieceIndex//(len(PIECES)//2))),
                                           col=pieceIndex%(len(PIECES)//2))
                self._allSprites.add(sprite)
                self._pieceSprites.add(sprite)
                if colour:
                    self._whiteSprites.add(sprite)
                else:
                    self._blackSprites.add(sprite)

            colour += 1


    def _spawn_objects(self):

        # Board Spawning
        self._boardBackdrop = Shape(self._container, BD_COLOUR, padx=0, pady=0, row=0, col=0, rowSpan=BOARD_ROW_SPAN, colSpan=BOARD_COL_SPAN)
        self._allSprites.add(self._boardBackdrop)

        self._board = Board(self._boardBackdrop, padx=20, pady=20, )
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
        self._screen.fill(BG_COLOUR)
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
    