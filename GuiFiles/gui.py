from sprites import Board, Shape, Piece
from GenericScreenElement import GenericScreenElement
from Constants import *
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

        self._all_sprites = pygame.sprite.Group()
        self.spawn_objects()


    @property
    def rows(self):
        return self._rows
    
    
    @property
    def cols(self):
        return self._cols

    
    def spawn_objects(self):

        # Board Spawning
        self._boardBackdrop = Shape(self._container, BD_COLOUR, padx=0, pady=0, row=0, col=0, rowSpan=BOARD_ROW_SPAN, colSpan=BOARD_COL_SPAN)
        self._all_sprites.add(self._boardBackdrop)

        self._board = Board(self._boardBackdrop, padx=20, pady=20, )
        self._all_sprites.add(self._board)

        colour = 0
        while colour < 2:
            for pieceIndex in range(len(PIECES)):
                self._all_sprites.add(Piece(self._board, colour=colour, piece=PIECES[pieceIndex], grid=(8,8), row=abs((7*colour)-(pieceIndex//(len(PIECES)//2))), col=pieceIndex%(len(PIECES)//2)))

            colour += 1



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


    def _draw(self):
        """"""

        for sprite in self._all_sprites:
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
    