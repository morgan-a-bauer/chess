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
        self._screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT), RESIZABLE)
        self._running = True
        self._rows = grid[0]
        self._cols = grid[1]
        self._container = GenericScreenElement(screen=self._screen, grid=GRID)

        self._allSprites   = pygame.sprite.Group()
        self._pieceSprites = pygame.sprite.Group()
        self._blackSprites = pygame.sprite.Group()
        self._whiteSprites = pygame.sprite.Group()

        self._players = [Player('white'), Player('black')]
        self._onTop = 0


        self._spawn_objects()

        self._turn = 1
        self._pieceMoved = False
        self._activePiece = None
        game_over(self._players[not(self._turn)], self._players[self._turn], self._board.container)


    @property
    def rows(self):
        return self._rows
    
    
    @property
    def cols(self):
        return self._cols
    

    def _populate_board(self):

        random.shuffle(self._players)

        for color in range(2):
            self._players[color].color = 'white' if color else 'black'

            for pieceIndex in range(len(PIECES)):
                
                piece  = PIECES[pieceIndex]  if not self._onTop else "queen" if PIECES[pieceIndex] == "king" else "king" if PIECES[pieceIndex] == "queen" else PIECES[pieceIndex] 
                row    = abs((7*(not(color) if self._onTop else color))-(pieceIndex//(len(PIECES)//2)))
                col    = pieceIndex%(len(PIECES)//2)
                
                sprite = Piece(player=self._players[color],
                                container=self._board,
                                screen=self._screen,
                                color=color,
                                piece=piece, 
                                grid=(8,8), 
                                row=row,
                                col=col)
                
                self._allSprites.add(sprite)
                self._pieceSprites.add(sprite)
                if color:
                    self._whiteSprites.add(sprite)
                else:
                    self._blackSprites.add(sprite)

                self._board.matrix[row][col] = sprite


    def _spawn_objects(self):

        # Board Spawning
        self._boardBackdrop = Shape(color=BD_COLOR, container=self._container, screen=self._screen, grid=(1,1), padx=0, pady=0, row=BOARD_ROW, col=BOARD_COL, rowSpan=BOARD_ROW_SPAN, colSpan=BOARD_COL_SPAN)
        self._allSprites.add(self._boardBackdrop)

        self._board = BoardSprite(container=self._boardBackdrop, screen=self._screen, grid=(8,8), padx=20, pady=20, row=0, col=0)
        self._allSprites.add(self._board)
        self._populate_board()


    def _check_events(self):
        """

        """
        for event in pygame.event.get():

            if event.type == KEYDOWN:

                if event.key == K_ESCAPE:
                    self._running = False

                if event.key == K_UP:
                    self._turn = not(self._turn)

                if event.key == K_LEFT:
                    game_over(self._players[self._turn], self._players[not(self._turn)], self._board.container)

                if event.key == K_RIGHT:
                    game_over(self._players[not(self._turn)], self._players[self._turn], self._board.container)

            if event.type == KEYUP:
                pass

            if event.type == MOUSEBUTTONDOWN:

                if event.button == 1:
                    self._select_grid(event.pos[0], event.pos[1])
                    
            elif event.type == QUIT:
                self._running = False


    def _select_grid(self, x, y):
        """
        row actually represents x coord
        col actually represents y coord
        """

        boardRow, boardCol = math.floor(y/(self._board.size[1]//8)), math.floor(x/(self._board.size[0]//8))
        # print(boardRow, boardCol)
        
        selected = self._board.matrix[boardRow][boardCol]
        print(selected, boardRow, boardCol)

        if selected in (self._whiteSprites if self._turn else self._blackSprites):
            self._activePiece = selected
            print(self._activePiece.piece.valid_moves)

        elif self._activePiece != None:

            if self._move(boardRow, boardCol):
                self._activePiece = None
                self._turn = not(self._turn)
                print(self._turn)
                print("just went:",self._players[not(self._turn)].name, "now turn:",self._players[self._turn].name)
                print(self._board.container)
                self._running = not(game_over(self._players[self._turn], self._players[not self._turn], self._board.container))

    
    def _move(self, row, col):
        """
        """
        # self._activePiece.piece.set_valid_moves(self._board.container)

        if (row,col) in self._activePiece.piece.valid_moves:
            if self._board.matrix[row][col] != 0:
                self._activePiece.capture_piece(self._board, row, col)
                # self._board.matrix[row][col].kill()

            else:
                self._board.remove_piece(self._activePiece)
                self._board.place_piece(self._activePiece, row, col)

            if type(self._activePiece.piece) in [Pawn, Rook, King]:
                self._activePiece.piece.has_moved = True

            # if type(self._activePiece.piece) == King and abs(self._activePiece.col - self._targetSquare[1]) == 2:
            #     if end < 4:
            #         rook = board.state[row][0]

            #     else:
            #         rook = board.state[row][-1]
            return True
        return False



    def _draw(self):
        """

        """
        for sprite in self._allSprites:
            self._screen.blit(sprite.surf, [*sprite.position])


    def _update_display(self):
        """
        
        """ 
        self._screen.fill(BG_COLOR)
        
        # draws all sprites
        # self._container.update()
        self._container.draw()
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
    