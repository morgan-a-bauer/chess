from math import ceil
from .constants import *
import pygame

class GenericScreenElement(pygame.sprite.Sprite):

    def __init__(self, parent=None, grid:tuple=(1,1), parentPosition:tuple=(0,0), parentSize:tuple=(SCREEN_WIDTH, SCREEN_HEIGHT), row:int=0, col:int=0, rowSpan:int=1, colSpan:int=1, padx:int=0, pady:int=0, **kwargs):
        """"""
        super(GenericScreenElement, self).__init__()
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
         padx:int=BOARD_PADX, 
         pady:int=BOARD_PADY, 
        """
        self._hasParent     = False             if parent == None else True

        self._grid          = grid
        self._parentWidth   = parentSize[0]     if parent == None else parent.size[0]
        self._parentHeight  = parentSize[1]     if parent == None else parent.size[1]
        self._parentX       = parentPosition[0] if parent == None else parent.position[0]
        self._parentY       = parentPosition[1] if parent == None else parent.position[1]

        self._row           = row
        self._col           = col
        self._rowSpan       = rowSpan
        self._colSpan       = colSpan
        self._padx          = padx
        self._pady          = pady
        self._position      = self._get_position_coord()
        self._size          = self._get_size()


    @property
    def containerDimensions(self):
        return (self._parentWidth, self._parentHeight)
    

    @containerDimensions.setter
    def containerDimensions(self, new:tuple):
        self._screenWidth  = new[0]
        self._screenHeight = new[1]
        self._update()

    @property
    def grid(self):
        return self._grid


    @grid.setter
    def grid(self, new:tuple):
        self._grid = new
        self._update()
    

    @property
    def row(self):
        return self._col
    

    @row.setter
    def row(self, new:int):
        self._col = new
        self._update()


    @property
    def col(self):
        return self._row
    

    @col.setter
    def col(self, new:int):
        self._row = new
        self._update()
    

    @property
    def padx(self):
        return self._padx
    

    @padx.setter
    def padx(self, new:int):
        self._padx = new
        self._update()


    @property
    def pady(self):
        return self._pady
    

    @pady.setter
    def pady(self, new:int):
        self._pady = new
        self._update()


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
    

    def _update(self):
        self._position = self._get_position_coord()
        self._size     = self._get_size()
    

    def _get_position_coord(self):
        return (ceil(( self._col * (self._parentHeight/self._grid[0])) + self._padx + self._parentX),
                ceil(( self._row * (self._parentWidth/self._grid[1] ) ) + self._pady + self._parentY),)


    def _get_size(self):
        return (ceil(( self._colSpan * (self._parentWidth/self._grid[0] ) ) - self._padx*2),
                ceil(( self._rowSpan * (self._parentHeight/self._grid[1]) ) - self._pady*2),)
    

if __name__ == '__main__':
    HEIGHT = 500
    WIDTH  = 500
    ROWS = 2
    COLS = 2
    obj = GenericScreenElement()
    print("position:",obj.position)
    print("size:",obj.size)
    print(obj.coords)

