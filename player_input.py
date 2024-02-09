"""
player_input.py
Morgan Bauer
I don't need helper functions for everything...But seriously, in this case,
it does actually clean up the client code.
"""
def name(num: int) -> str:
    """Asks for and returns the player's name"""
    p_name = input(f"Welcome to Chess! Player {num}, Please enter your name: ")

    return p_name


def start_space_an() -> str:
    """Asks for and returns the space of the piece to be moved"""
    start = input("Please enter the name of the space containing" +
                        " the piece you would like to move: ")

    return start


def new_space_an() -> str:
    """Asks for and returns the space to move the piece to"""
    end = input("Please enter the name of the space the you would" +
                   " like to move your piece to: ")

    return end


def confirm_start_an() -> str:
    """Confirms the decision to move the piece given as input"""
    ans = input("Please confirm that this is the piece you would like to move (Y/N): ")

    return ans


def confirm_new_an() -> str:
    """Confirms the decision to move a piece to this space"""
    ans = input("Please confirm that this is the space you would like to move to (Y/N): ")

    return ans