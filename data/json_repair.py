import json
import os
import ast

with open(os.path.abspath("data/jsonObjects/pgnDataAsJson.json"), "r") as textFile:
    dictionary = ast.literal_eval(textFile.read().strip())
    with open(os.path.abspath("data/jsonObjects/pgnDataAsJson_corrected.json"), 'w') as file:
        json.dump(dictionary, file)