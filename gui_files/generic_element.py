from math import ceil
from .constants import *
import itertools as it
import pygame


class GenericScreenElement(pygame.sprite.Sprite):

    def __init__(self, screen, 
                parent=None,  
                grid:tuple=(1,1), 
                row:int=0, 
                col:int=0, 
                rowSpan:int=1, 
                colSpan:int=1, 
                padx:int=0, 
                pady:int=0, 
                parentGrid:tuple=(1,1), 
                img:str=None,
                alpha:int=255,
                fillColor:tuple=WHITE,
                parentPosition:tuple=(0,0),
                parentSize:tuple=(SCREEN_WIDTH, SCREEN_HEIGHT),
                **kwargs):
        """
         You need to supply 

         parent:GenericScreenElement
         or
         grid:tuple=None, 
         
         parentPosition:tuple=(0,0), 
         parentSize:tuple=(SCREEN_WIDTH, SCREEN_HEIGHT), 
         row:int=BOARD_ROW, 
         col:int=BOARD_COL, 
         rowSpan:int=BOARD_ROW_SPAN, 
         colSpan:int=BOARD_COL_SPAN, 
         padx:int=BOARDpadx, 
         pady:int=BOARDpady, 
        """
        super(GenericScreenElement, self).__init__()
        self._screen        = screen
        self._parent        = parent

        self._parentGrid     = parentGrid
        self._parentPosition = parentPosition
        self._parentSize     = parentSize

        self._children      = []


        self._grid          = grid
        self._row           = row
        self._col           = col
        self._rowSpan       = rowSpan
        self._colSpan       = colSpan
        self.padx           = padx
        self.pady           = pady

        if self._parent != None:
            self._parent._children.append(self)
            self._position = self._get_position()
            self._size     = self._get_size()
        else:
            self._position = self._get_position_no_parent()
            self._size     = self._get_size_no_parent()

        self._img = img
        self._fillColor = fillColor
        if self._img != None:
            self._img.set_alpha(alpha)
            self.surf = pygame.transform.scale(self._img, [*self.size])
            self.surf.set_colorkey((255,255,255), RLEACCEL)
        else:
            self.surf = pygame.Surface([*self.size])
            self.surf.fill(self._fillColor)

        self.rect   = self.surf.get_rect()

        self.update()


    @property
    def grid(self):
        return self._grid

    @grid.setter
    def grid(self, new:tuple):
        self._grid = new


    @property
    def cellCorners(self):
        cellCorners = [(((self.size[0]//self._grid[0])*x) + self.padx + self._parent.position[0], ((self.size[1]//self._grid[1])*y) + self.pady + self._parent.position[1]) for x,y in zip(range(1, self._grid[0]), range(1, self._grid[1]))]
        cellCorners.insert(0, self.position)
        cellCorners.append(self.coords)
        return cellCorners


    @property
    def row(self):
        return self._row
    

    @row.setter
    def row(self, new:int):
        self._row = new


    @property
    def col(self):
        return self._col
    

    @col.setter
    def col(self, new:int):
        self._col = new


    @property
    def position(self):
        return (self._position)
    

    @property
    def size(self):
        return self._size
    

    @property
    def coords(self):
        return (self._size[0] + self._position[0],
                self._size[1] + self._position[1],)
    
    
    def move(self, row, col):
        self._row = row
        self._col = col
    

    def update(self):
        if self._parent != None:
            self._position = self._get_position()
            self._size     = self._get_size()
        else:
            self._position = self._get_position_no_parent()
            self._size     = self._get_size_no_parent()
        
        if self._img != None:
            self.surf = pygame.transform.scale(self._img, [*self.size])
            self.rect = self.surf.get_rect()
        else:
            self.surf = pygame.Surface([*self.size])
            self.surf.fill(self._fillColor)
            self.rect = self.surf.get_rect()



    def draw(self):
        self.update()
        self._screen.blit(self.surf, [*self.position])
        for child in self._children:
            child.draw()


    def _get_position(self,):
        return (ceil(( self._col * (self._parent.size[0]/self._parent.grid[0])) + self.padx + self._parent.position[0]),
                ceil(( self._row * (self._parent.size[1]/self._parent.grid[1] ) ) + self.pady + self._parent.position[1]),)
    

    def _get_size(self,):
        return (ceil(( self._colSpan * (self._parent.size[0]/self._parent.grid[0] ) ) - self.padx*2),
                ceil(( self._rowSpan * (self._parent.size[1]/self._parent.grid[1]) ) - self.pady*2),)
    
    def _get_position_no_parent(self,):
        return (ceil(( self._col * (self._screen.get_size()[1]/self._parentGrid[0])) + self.padx + self._parentPosition[0]),
                ceil(( self._row * (self._screen.get_size()[0]/self._parentGrid[1] ) ) + self.pady + self._parentPosition[1]),)
    
    def _get_size_no_parent(self,):
        return (ceil(( self._colSpan * (self._screen.get_size()[0]/self._parentGrid[0] ) ) - self.padx*2),
                ceil(( self._rowSpan * (self._screen.get_size()[1]/self._parentGrid[1]) ) - self.pady*2),)
    
    
    def delete(self):
        self.kill()
        self._parent._children.remove(self)


if __name__ == '__main__':
    HEIGHT = 500
    WIDTH  = 500
    ROWS = 2
    COLS = 2
    obj = GenericScreenElement()
    print("position:",obj.position)
    print("size:",obj.size)
    print(obj.coords)

