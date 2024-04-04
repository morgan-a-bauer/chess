from math import ceil
from Constants import *

class GenericScreenElement():

    def __init__(self, row:int=BOARD_ROW, col:int=BOARD_COL, rowSpan:int=BOARD_ROW_SPAN, colSpan:int=BOARD_COL_SPAN, padx:int=BOARD_PADX, pady:int=BOARD_PADY):
        """"""
        self._screenWidth   = SCREEN_WIDTH
        self._screenHeight  = SCREEN_HEIGHT
        self._row           = row
        self._col           = col
        self._rowSpan       = rowSpan
        self._colSpan       = colSpan
        self._padx          = padx
        self._pady          = pady
        self._position      = self._get_position_coord()
        self._size          = self._get_size()


    @property
    def update_screen_dimensions(self):
        return (self._screenWidth, self._screenHeight)
    

    @update_screen_dimensions.setter
    def update_screen_dimensions(self, new:tuple):
        self._screenWidth  = new[0]
        self._screenHeight = new[1]
        self._update_position()


    @property
    def row(self):
        return self._row
    

    @row.setter
    def row(self, new:int):
        self._row = new
        self._update_position()


    @property
    def col(self):
        return self._col
    

    @col.setter
    def col(self, new:int):
        self._col = new
        self._update_position()
    

    @property
    def padx(self):
        return self._padx
    

    @padx.setter
    def padx(self, new:int):
        self._padx = new
        self._update_position()


    @property
    def pady(self):
        return self._pady
    

    @pady.setter
    def pady(self, new:int):
        self._pady = new
        self._update_position()


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
    

    def _update_position(self):
        self._position = self._get_position_coord()
        self._size     = self._get_size()
    

    def _get_position_coord(self):
        return (ceil(( self._row * (self._screenHeight/GRID[0]) ) + self._padx),
                ceil(( self._col * (self._screenWidth/GRID[1] ) ) + self._pady),)


    def _get_size(self):
        return (ceil(( self._colSpan * (self._screenWidth/GRID[0] ) ) - self._padx*2),
                ceil(( self._rowSpan * (self._screenHeight/GRID[1]) ) - self._pady*2),)
    

if __name__ == '__main__':
    HEIGHT = 500
    WIDTH  = 500
    ROWS = 2
    COLS = 2
    obj = GenericScreenElement()
    print("position:",obj.position)
    print("size:",obj.size)
    print(obj.coords)

