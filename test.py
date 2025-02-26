import stockfish
import os

test_moves = ['c4', 'e6', 'd4', 'd5'] #, 'Nf3', 'c6', 'e3', 'Nf6', 'Nbd2', 'c5',
#               'b3', 'cxd4', 'exd4', 'Nc6', 'Bb2', 'Be7', 'Bd3', 'O-O', 'O-O',
#               'b6', 'Re1', 'Bb7', 'Rc1', 'Rc8', 'c5', 'Nb4', 'Bb1', 'bxc5',
#               'dxc5', 'Rxc5', 'a3', 'Rxc1', 'Qxc1', 'Nc6', 'b4', 'Re8', 'Nf1',
#               'Nb8', 'Qe3', 'a5', 'b5', 'Nbd7', 'Rc1', 'Bd6', 'Ng3', 'Qe7',
#               'a4', 'Bc5', 'Qd3', 'Bb6', 'Ne5', 'Nxe5', 'Bxe5', 'g6', 'Bb2',
#               'e5', 'Qd2', 'd4', 'Qg5', 'Nd5', 'Qg4', 'Nf4', 'Re1', 'Nxg2',
#               'Rc1', 'Nf4', 'Be4', 'Bxe4', 'Nxe4', 'f5', 'Qd1', 'fxe4', 'Rc6',
#               'Qg5+', 'Kf1', 'Qg2+', 'Ke1', 'Nd3+', 'Qxd3', 'exd3', 'Rxb6',
#               'Qg1+', 'Kd2', 'Qxf2+', 'Kxd3', 'Qxb2', 'Ke4', 'Qe2+', 'Kd5',
#               'd3', 'Kd6', 'd2', 'Kd7', 'Rf8', 'Ke7', 'd1=Q', 'Rd6', 'Qxd6+',
#               'Kxd6', 'Qc4', 'Ke7', 'Qxa4', 'b6', 'Qb4+', 'Kd7', 'Qxb6', 'h4',
#               'Ra8', 'h5', 'Ra7+', 'Ke8']

def knight_is_original_
def pgn_to_full_algebraic(moves: list) -> list:
    """Converts a list of chess moves in pgn notation to full algebraic notation.
    This is necessary for processing input tensors and evaluating """
    curr_state = [['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'],
                  ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
                  ['',  '',  '',  '',  '',  '',  '',  ''],
                  ['',  '',  '',  '',  '',  '',  '',  ''],
                  ['',  '',  '',  '',  '',  '',  '',  ''],
                  ['',  '',  '',  '',  '',  '',  '',  ''],
                  ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
                  ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']]
    full_an_moves = []
    curr_turn = 0  # 0 for white, 1 for black

    for move in moves:
        print(full_an_moves)

        # CASE 1: Forward pawn movement
        if len(move) == 2:
            col = ord(move[0]) - 97  # Convert file letter to an integer
            row = 8 - int(move[1])  # Convert labelled row number to matrix index

            # Check for white pawns
            if curr_turn == 0:

                # If the pawn could have moved forward two spaces
                if row == 4:
                    if curr_state[6][col] == 'P':
                        prev_space = chr(col + 97) + str(8 - (row + 2))

                # If the pawn could have moved forward one space
                if curr_state[row + 1] == 'P':
                    prev_space = chr(col + 97) + str(8 - (row + 1))

            # Check for black pawns
            else:

                # If the pawn could have moved forward two spaces
                if row == 3:
                    if curr_state[1][col] == 'p':
                        prev_space = chr(col + 97) + str(8 - (row - 2))

                # If the pawn could have moved forward one space
                if curr_state[row - 1][col] == 'p':
                    prev_space = chr(col + 97) + str(8 - (row - 1))

            # Recast the move in full algebraic notation
            full_an_move = prev_space + move

        # CASE 2: Non-capturing movement for non-pawn pieces
        if len(move) == 3:
            piece = move[0]
            col = ord(move[1]) - 97
            row = 8 - int(move[1])

            # If black is the active player
            if curr_turn == 1:
                piece = piece.lower()

        # Append full algebraic notation move to updated list
        full_an_moves.append(full_an_move)

        # Switch the current player
        curr_turn = (curr_turn + 1) % 2

    return full_an_moves

moves = pgn_to_full_algebraic(test_moves)
print(moves)
