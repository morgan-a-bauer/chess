from BoardSprite import Board
import pygame
from Constants import *



class Gui:

    def __init__(self, grid:tuple=GRID):
        """
        
        """
        self._screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        self._running = True
        self._rows = grid[0]
        self._cols = grid[1]

        self.spawn_objects()


    @property
    def rows(self):
        return self._rows
    
    
    @property
    def cols(self):
        return self._cols

    
    def spawn_objects(self):
        # Board Spawning
        self._board = Board()


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
        self._screen.blit(self._board.surf, [*self._board.position])
    

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
    