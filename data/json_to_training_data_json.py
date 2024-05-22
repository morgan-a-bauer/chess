import os
import json
import random
from stockfish import Stockfish
"""
What does this file need to do?

Take a json object containing n games
Isolate move information
Iterate through moves
Fill a board state list (S) with state after each move
^ looks like [0...32] with each index being the position of piece on the board last index is current player's turn
inputTensor = [*S, currentTurn]
stockfish eval of board state for target variable

class BoardStateConverter:
    jsonFile : str = "pgnDataAsJson"
    labels : list = ["moves", "currentMove"]
    target : str = "stockfish-eval"
    stockfishBoardState = "/opt/homebrew/Cellar/stockfish/16.1/bin/stockfish" or ./stockfish

    inputTensors: list = []


    
Methods

load_json_file: -> list
# entire list? or 

grab_labels: -> list
use labels from constructure params
return list from json file with only target labels

stockfish_eval: -> float
takes move as input
returns evaluation

convert_labels_to_representation: -> list
iterate through lists

save_tensor_as_json: -> None

"""

class BoardStateConverter:

    def __init__(self, stockfish="stockfish", labels=["moves", "currentTurn"], target="stockfish-eval"):
        self.workingDir = os.path.abspath("data")
        self.stockfish = Stockfish(os.path.join(self.workingDir,stockfish))
        self.labels = labels
        self.target = target
        

    def load_label_data_from_json(self, jsonFileDir="jsonObjects/pgnDataAsJson.json"):
        # loads just the labels requested?


        # Need to add os usage for abs path once "__main__" is in final dir location
        print(os.path.join(self.workingDir, jsonFileDir))
        with open(os.path.join(self.workingDir, jsonFileDir), "r") as gamesFile:

            gameData = json.load(gamesFile)


            for game in gameData:
                labelValues = []
                






if __name__ == "__main__":
    converter = BoardStateConverter()
    converter.load_label_data_from_json()


