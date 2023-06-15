class Board:
    def __init__(self):
        self._state = [[0 for i in range(8)] for j in range(8)]

    def __str__(self):
        printed_board = []
        for row in self.state:
            row = [str(space) for space in row]
            printed_board.append(''.join(row))
        return '\n'.join(printed_board)

if __name__ == "__main__":
    my_board = Board()
    print(my_board)