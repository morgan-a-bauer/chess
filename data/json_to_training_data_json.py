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

# RUN FROM chess directory
class BoardStateConverter:

    def __init__(self, stockfish="stockfish", stockfishRating = 2000):
        self.workingDir = os.path.abspath("data")
        self.stockfish = Stockfish(os.path.join(self.workingDir,stockfish))

        self.inputTensor = []

    def stockfish_eval(self, moves):
        self.stockfish.set_position(moves)
        return self.stockfish.get_evaluation()

    def process_json_file(self, jsonFileDir="jsonObjects/pgnDataAsJson_corrected.json") -> list:
        # loads just the labels requested

        # opens json file
        with open(os.path.join(self.workingDir, jsonFileDir), "r") as gamesFile:

            for moves in json.load(gamesFile):
                boardStates, stockfishMoves =  self.convert_labels_to_representation(moves)
                
                stockfishEval = self.stockfish_eval(stockfishMoves)

                self.inputTensor.append([boardStates, stockfishEval])
                # print(moves)
    
    def write_as_json(self, jsonFileDir="trainingData/training_data.json"):
        
        with open(os.path.join(self.workingDir, jsonFileDir), "w") as file:

            json.dump(self.inputTensor, file)

            
if __name__ == "__main__":
    converter = BoardStateConverter()
    converter.process_json_file()

