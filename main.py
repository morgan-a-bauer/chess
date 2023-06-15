from board import Board
from player import Player
from pieces.base_piece import BasePiece
from pieces.pawn import Pawn

def main():
    board = Board()
    players = []
    for new_color, row in zip(("white", "black"), (1, 6)):
        new_player = Player(new_color)
        players.append(new_player)
        for col in range(8):
            new_pawn = Pawn((row, col), new_color)
            board.update_state(new_pawn)
            new_player.gain_piece(new_pawn)
    print(board)


if __name__ == "__main__":
    main()