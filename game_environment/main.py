"""
main.py
Morgan Bauer
A digital representation of the game chess. Intended for use to test
functionality of our chess models using neural networks
"""
from board import Board
from player import Player
from pieces.base_piece import BasePiece
from pieces.pawn import Pawn
from pieces.rook import Rook
from pieces.knight import Knight
from pieces.bishop import Bishop
from pieces.queen import Queen
from pieces.king import King
import game_environment.utils as utils


def main():
    """A standard game of chess"""

    # Set up game environment
    board = Board()
    players = utils.get_players()
    utils.setup_board(board, players)
    player_index = 0  # keep track of whose move it is
    game_over = utils.game_over(players[1], players[0], board)

    # a generic turn
    while not game_over:
        print(board)
        curr_player = players[player_index]
        opp_player = players[int(not player_index)]

        # Player moves a piece
        utils.move(board, curr_player, opp_player)

        # Switch active player
        player_index = int(not player_index)

        # Check game end condition
        game_over = utils.game_over(opp_player, curr_player, board)

    # Print a message when the game is over
    print(f"{game_over}!", end = " ")
    if game_over == "Checkmate":
        print(f"{curr_player.name} won!")
    else:
        print("It was a draw!")


if __name__ == "__main__":
    main()