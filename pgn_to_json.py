"""
    Jackson Butler
    Converts a folder of pgns to a single large json object
    This will be cleaned up, just my prototyping process :)
"""

import json
import os
import re

pgnLocation = os.path.abspath("lichess_database")
# pgnList = sorted([file for file in os.listdir(pgnLocation) if os.path.join(pgnLocation, file).endswith(".pgn")], key=lambda x:x[14:-4], reverse=True)
# print(pgnList)

pgnJsonObject = {}
pgnList = ('lichess_elite_2013-09.pgn',)

for file in pgnList:
    with open(os.path.join(pgnLocation, file), 'r') as pgn:
        pgnContent = pgn.readlines()
        print(pgnContent[:50])

        for pgnLine in pgnContent[:20]:
            result = re.sub("[\[\]]", '', pgnLine).strip()
            print(result)
            result = re.split(r'\s(?=(?:[^"]*"[^"]*")*[^"]*$)', result, maxsplit=1)
            result[1] = result[1].strip('"')
            print(result)
            
            # TODO: Create clause for empty lines and then actual game moves
        
        
        
