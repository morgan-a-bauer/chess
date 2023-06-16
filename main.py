from board import Board
from player import Player
from pieces.base_piece import BasePiece
from pieces.pawn import Pawn
from pieces.rook import Rook
from pieces.knight import Knight
from pieces.bishop import Bishop
from pieces.queen import Queen
from pieces.king import King
from utils import *

def generate_pawns(board: Board, player: Player, row: int, color: str) -> None:
    for col in range(8):
                new_pawn = Pawn((row, col), color)
                board.update_state(new_pawn)
                player.gain_piece(new_pawn)


def generate_rooks(board: Board, player: Player, row: int, color: str) -> None:
    for col in (0, 7):
            rook = Rook((row, col), color)
            board.update_state(rook)
            player.gain_piece(rook)



def generate_knights(board: Board, player: Player, row: int, color: str) -> None:
    for col in (1, 6):
            new_knight = Knight((row, col), color)
            board.update_state(new_knight)
            player.gain_piece(new_knight)


def generate_bishops(board: Board, player: Player, row: int, color: str) -> None:
    for col in (2, 5):
            new_bishop = Bishop((row, col), color)
            board.update_state(new_bishop)
            player.gain_piece(new_bishop)


def generate_queen(board: Board, player: Player, row: int, color: str) -> None:
      col = 3
      new_queen = Queen((row, col), color)
      board.update_state(new_queen)
      player.gain_piece(new_queen)


def generate_king(board: Board, player: Player, row: int, color: str) -> None:
      col = 4
      new_king = King((row, col), color)
      board.update_state(new_king)
      player.gain_piece(new_king)


def setup_board(new_board: Board, player_lyst: list) -> None:
    for new_color, row in zip(("white", "black"), (6, 1)):
        new_name = input("Hi there! Please enter your name: ")
        new_player = Player(new_name, new_color)
        player_lyst.append(new_player)
        generate_pawns(new_board, new_player, row, new_color)
        row = round((1.4 * row) - 1.4)
        generate_rooks(new_board, new_player, row, new_color)
        generate_knights(new_board, new_player, row, new_color)
        generate_bishops(new_board, new_player, row, new_color)
        generate_queen(new_board, new_player, row, new_color)
        generate_king(new_board, new_player, row, new_color)


def game_over() -> bool:
      return False


def move(board: Board, player: Player) -> None:
    print(f"{player.name}'s turn")
    starting_an = input("Please enter the name of the space containing" +
                        "the piece you would like to move: ")
    new_an = input("Please enter the name of the space the you would" +
                   "like to move your piece to: ")


def main():
    board = Board()
    players = []
    setup_board(board, players)
    player_index = 0 # keep track of whose move it is
    while not game_over():
        print(board)
        curr_player = players[player_index]
        move(board, curr_player)


if __name__ == "__main__":
    main()