"""
utils.py
Morgan Bauer
The utility functions needed to carry out in-game actions for a chess game
"""
from player import Player
from board import Board
from pieces.base_piece import BasePiece
from pieces.pawn import Pawn
from pieces.bishop import Bishop
from pieces.knight import Knight
from pieces.rook import Rook
from pieces.queen import Queen
from pieces.king import King
import player_input
import random
import chess_errors

def algebraic_to_grid(space: str) -> tuple:
    """
    Converts a space in algebraic notation (e.g. B5) to grid notation for
    indexing the board
    Inputs:
        space -- a string representing a space on the chess board
    """
    col = ord(space[0].lower())
    row = int(space[1])
    if (col < 97) or (col > 104):
        return False
    if (row < 1) or (row > 8):
        return False
    col -= 97
    row -= 1
    return (row, col)


def grid_to_algebraic(coords: tuple) -> str:
    """
    Converts an ordered pair of grid coordinates (e.g. (4, 5)) to algebraic
    notation to look pretty
    Input:
        coords -- a tuple containing the coordinates of a Piece on a Board
    """
    row = coords[0]
    col = coords[1]
    row_an = str(row + 1)
    col_an = chr(col + 97)
    return col_an + row_an


def is_valid_an(space: str) -> bool:
    """
    Determines if a space entered by the user is a valid space on the board
    represented in algebraic notation. Returns True if the space given is valid,
    otherwise returns False
    Inputs:
        space -- A string representing a space on the chess board
    """
    if space == None:
        return False
    if len(space) != 2:
        return False
    row = space[0]
    col = space[1]
    if (row not in 'abcdefgh') and (row not in 'ABCDEFGH'):
        return False
    if col not in '12345678':
        return False
    return True


def is_players_piece(player_color: str, row: int, col: int, board: Board) -> bool:
    """
    Determines if a piece is a player's piece by comparing the player's
    color with the piece's color
    Inputs:
        player_color -- well...
        row -- the row of the current Board state containing the piece
        col -- the column of the current Board state containing the piece
        board -- the active Board object"""
    space = board.state[row][col]
    if space == 0:
        return False
    piece_color = space.color # The color of the piece at space
    if player_color == piece_color:
        return True
    return False


def get_players() -> list:
    """
    Gets the names of both players, then shuffles them to randomly assign
    white and black and returns the resulting list
    """
    players = []
    for player_num in range(1, 3):
        new_name = player_input.name(player_num)
        new_player = Player(new_name)
        players.append(new_player)
    random.shuffle(players)
    return players

def generate_pawns(board: Board, player: Player, row: int) -> None:
    """
    Creates 8 Pawn instances for a given player and places them on the board in
    the opening state
    Inputs:
        board -- a Board object
        player -- a Player object
        row -- the row number of the new pawn
    """
    for col in range(8):
        new_pawn = Pawn((row, col), player.color)
        board.place_piece(new_pawn, row, col)
        player.gain_piece(new_pawn)


def generate_rooks(board: Board, player: Player, row: int) -> None:
    """
    Creates 2 Rook instances for a given player and places them on the board in
    the opening state
    Inputs:
        board -- a Board object
        player -- a Player object
        row -- the row number of the new rook
    """
    for col in (0, 7):
        rook = Rook((row, col), player.color)
        board.place_piece(rook, row, col)
        player.gain_piece(rook)


def generate_knights(board: Board, player: Player, row: int) -> None:
    """
    Creates 2 Knight instances for a given player and places them on the board
    in the opening state
    Inputs:
        board -- a Board object
        player -- a Player object
        row -- the row number of the new knight
    """
    for col in (1, 6):
        new_knight = Knight((row, col), player.color)
        board.place_piece(new_knight, row, col)
        player.gain_piece(new_knight)


def generate_bishops(board: Board, player: Player, row: int) -> None:
    """
    Creates 2 Bishop instances for a given player and places them on the board
    in the opening state
    Inputs:
        board -- a Board object
        player -- a Player object
        row -- the row number of the new bishop
    """
    for col in (2, 5):
        new_bishop = Bishop((row, col), player.color)
        board.place_piece(new_bishop, row, col)
        player.gain_piece(new_bishop)


def generate_queen(board: Board, player: Player, row: int) -> None:
    """
    Creates a Queen instances for a given player and places it on the board in
    the opening state
    Inputs:
        board -- a Board object
        player -- a Player object
        row -- the row number of the new queen
    """
    col = 3
    new_queen = Queen((row, col), player.color)
    board.place_piece(new_queen, row, col)
    player.gain_piece(new_queen)


def generate_king(board: Board, player: Player, row: int) -> None:
    """
    Creates a King instances for a given player and places it on the board in
    the opening state
    Inputs:
        board -- a Board object
        player -- a Player object
        row -- the row number of the new king
    """
    col = 4
    new_king = King((row, col), player.color)
    board.place_piece(new_king, row, col)
    player.gain_piece(new_king)


def setup_board(new_board: Board, player_lyst: list) -> None:
    """
    Calls functions to create new players and generate pieces for each player
    playing.
    Inputs:
        new_board -- a Board object
        player_lyst -- a list of player names
    """
    for new_color, row, new_player in zip(("white", "black"), (1, 6), (player_lyst)): #Should this be (6, 1)?
        new_player.color = new_color
        print(f'{new_player.name} will be {new_color}')
        generate_pawns(new_board, new_player, row)
        row = round((1.4 * row) - 1.4)
        generate_rooks(new_board, new_player, row)
        generate_knights(new_board, new_player, row)
        generate_bishops(new_board, new_player, row)
        generate_queen(new_board, new_player, row)
        generate_king(new_board, new_player, row)


def game_over() -> bool:
    #TODO
    """
    Evaluates the state of the board and returns a boolean value reflecting
    if the game is over or not
    """
    return False


def start_space(board: Board, player: Player) -> tuple:
    """
    Asks the user for the space containing the piece they would like to move
    """
    start_an = ''
    piece_color = ''
    row = -1
    col = -1
    valid_an = False
    while not valid_an:
        try:
            start_an = player_input.start_space_an()
            if not is_valid_an(start_an):
                raise chess_errors.ANError("This is not a valid space in algebraic notation,")
            grid_coords = algebraic_to_grid(start_an)
            row = grid_coords[0]
            col = grid_coords[1]
            if board.state[row][col] == 0:
                raise chess_errors.NoPieceError("There is no piece on this space,")
            if not is_players_piece(player.color, row, col, board):
                raise chess_errors.OppPieceError("This is not your piece,")
            confirm = ''
            while confirm not in ('Y', 'y', 'Yes', 'yes', 'N', 'n', 'No', 'no'):
                confirm = player_input.confirm_start_an()
            if confirm == 'N':
                continue
            return (row, col)
        except chess_errors.ANError as err:
            print(str(err) + " please try again.")
        except chess_errors.NoPieceError as err:
            print(str(err) + " please try again.")
        except chess_errors.OppPieceError as err:
            print(str(err) + " please try again.")


def new_space(board: Board, player: Player) -> tuple:
    """
    Asks the user for the space the would like to move a piece to
    """
    new_an = ''
    piece_color = ''
    row = -1
    col = -1
    valid_an = False
    while not valid_an:
        try:
            new_an = player_input.new_space_an()
            if not is_valid_an(new_an):
                raise chess_errors.ANError("This is not a valid space in algebraic notation,")
            grid_coords = algebraic_to_grid(new_an)
            row = grid_coords[0]
            col = grid_coords[1]
            confirm = ''
            while confirm not in ('Y', 'y', 'Yes', 'yes', 'N', 'n', 'No', 'no'):
                confirm = player_input.confirm_new_an()
            if confirm == 'N':
                continue
            return (row, col)
        except chess_errors.ANError as err:
            print(str(err) + " please try again.")



def move(board: Board, player: Player) -> None:
    """
    Gets the space containing the active player's piece and the space the player
    would like to move that piece to and carries out that action if it is a
    valid move
    Input:
    board -- a Board object
    player -- the Player object corresponding to the active player
    """
    print(f"{player.name}'s turn")

    start_coords = start_space(board, player)
    start_row = start_coords[0]
    start_col = start_coords[1]
    piece_to_move = board.state[start_row][start_col]
    possible_moves = piece_to_move.valid_moves()
    an_moves = [grid_to_algebraic(move) for move in possible_moves]
    print("Your possible moves are:", end = " ")

    for an_move in an_moves:
        print(an_move, end = " ")
    print()

    new_row, new_col = new_space(board, player)
    piece = board.state[start_row][start_col]
    board.remove_piece(piece)
    board.place_piece(piece, new_row, new_col)
    if type(piece) == Pawn:
            piece.has_moved = True


if __name__ == "__main__":
    user_input = 'l'
    while user_input != 'x':
        user_input = input("Please enter the name of a space on a chess board: ")
        grid_coords = algebraic_to_grid(user_input)
        print("Your coordinates are: ", grid_coords)
        algeb_coords = grid_to_algebraic(grid_coords)
        print("Your algebraic coordinates are: ", algeb_coords)
    print('=' * 100)