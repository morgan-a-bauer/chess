import os
import json
import random
import numpy as np
import pandas as pd
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

        self.tensor = {
            'input':[], 
            'target':
                {'move':[], 
                 'eval':[]}}
        

    def stockfish_eval(self, moves):
        self.stockfish.set_position(moves)
        bestMove = self.stockfish.get_best_move(25)
        evaluation = self.stockfish.get_evaluation()
        return bestMove, evaluation
    
    
    def process_json_file(self, jsonFileDir="jsonObjects/pgnDataAsJson_corrected.json") -> list:
        # loads just the labels requested
    
        # opens json file
        # chunks = pd.read_json(jsonFileDir, lines=True, chunksize = 100)
        # for chunk in chunks:
        #     print(chunk)

        with open(os.path.join(self.workingDir, jsonFileDir), "r") as gamesFile:
            print("working")
            
            for moves in json.load(gamesFile):
                boardState = ['foo']
                moves = ['bar']
                stockfishNextMove, stockfishEval =  self.stockfish_eval(moves)

                self.tensor['input'].append(boardState)
                # self.tensor['target']['move'].append(stockfishNextMove) # Needs to be converted to numeric before used
                self.tensor['target']['eval'].append((0 if stockfishEval['type'] == 'cp' else 1, stockfishEval['value']))

    
    def write_as_json(self, content, jsonFileDir="trainingData/training_data.json"):
        
        with open(os.path.join(self.workingDir, jsonFileDir), "w") as file:

            json.dump(content, file)

            
if __name__ == "__main__":
    converter = BoardStateConverter()
    converter.process_json_file()
    converter.write_as_json(converter.tensor, "trainingData/training_data.json")
    converter.write_as_json(converter.normalDataInfo, "trainingData/normalizedTrainingData.json")

    # moves =  ['e2e4', 'e7e6', 'e1e2']
    # moves = ['d2d4','d7d6','d4d5','e7e6','d5e6','a7a6','e6e7','e8d7','e7e8Q']
    # moves = ['d2d4','d7d6']

    # workingDir = os.path.abspath("data")
    # stockfish = Stockfish(os.path.join(workingDir,"stockfish"))
    # stockfish.set_position(moves)
    # print(stockfish.get_best_move(25))
    # print(stockfish.get_evaluation())
    # # Two types of evaluation cp or mate
    # # cp HIGHER is better
    # # mate LOWER is better


    # print(stockfish.get_board_visual())
    





