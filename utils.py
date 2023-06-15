def algebraic_to_grid(space):
    x_coord = ord(space[0])
    y_coord = int(space[1])
    if (x_coord < 96) or (x_coord > 104):
        return False
    if (y_coord < 1) or (y_coord > 8):
        return False
    x_coord -= 97
    y_coord -= 1
    return (x_coord, y_coord)

if __name__ == "__main__":
    user_input = 'l'
    while user_input != 'x':
        user_input = input("Please enter the name of a space on a chess board: ")
        grid_coords = algebraic_to_grid(user_input)
        print("Your coordinates are: ", grid_coords)