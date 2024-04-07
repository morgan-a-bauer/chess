from pygame.locals import (
    RLEACCEL,
    K_UP,
    K_DOWN,
    K_LEFT,
    K_RIGHT,
    K_ESCAPE,
    MOUSEBUTTONDOWN,
    KEYDOWN,
    KEYUP,
    QUIT,
)
import os

print(os.getcwd())

FOLDER_PATH        = os.path.abspath("GuiFiles")
SPRITE_FOLDER_PATH = os.path.join(FOLDER_PATH, "sprites/")
PIECES_FOLDER_PATH = os.path.join(SPRITE_FOLDER_PATH, "pieces/")
WHITE_PIECE = os.path.join(PIECES_FOLDER_PATH, "white")
BLACK_PIECE = os.path.join(PIECES_FOLDER_PATH, "black")

# Screen Specifications
SCREEN_WIDTH       = 1000
SCREEN_HEIGHT      = 1000
GRID               = (4,4)

BG_COLOR          = (9,11,16)
BD_COLOR          = (225,204,183)
WHITE              = (255,255,255)

# Board Specifications
BOARD_SPRITE       = "Chess_board.png"
# BOARD_WIDTH        = 1  # SCREEN_WIDTH // BOARD_WIDTH
# BOARD_HEIGHT       = 1  # SCREEN_HEIGHT // BOARD_HEIGHT

BOARD_ROW          = 0
BOARD_COL          = 0
BOARD_ROW_SPAN     = 3
BOARD_COL_SPAN     = 3

BOARD_PADX         = 20
BOARD_PADY         = 20

PIECES             = ["rook", "knight", "bishop", "queen", "king", "bishop", "knight", "rook",
                      "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn", "pawn"]

PIECE_DICT         = ""


