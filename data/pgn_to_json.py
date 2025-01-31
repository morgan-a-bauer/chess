"""
    Jackson Butler
    Converts a folder of pgns to a single large json object
    This will be cleaned up, just my prototyping process :)
"""

import json
import os
import re

dataLocation = os.path.abspath("data")
pgnLocation = dataLocation + "/lichessData"
jsonLocation = dataLocation + "/jsonObjects"
jsonFileName = "pgnDataAsJson_corrected_test.json"
pgnList = sorted([file for file in os.listdir(pgnLocation) if os.path.join(pgnLocation, file).endswith(".pgn")], key=lambda x:x[14:-4], reverse=True)
# print(pgnList)

pgnJsonObject = []
pgnObjectIndex = -1
iterCount = 0
"""
    Example Structure:

    [{
        'Event' : 'Rated Blitz game',
        'Date'  : '2013.09.10',
        'Result': '1-0',
        ...

    },{
        'Event' : 'Rated Blitz game',
        ...
    }]

    """

# pgnList = ('lichess_elite_2013-09.pgn',)

for file in pgnList:
    savingMoves = False
    with open(os.path.join(pgnLocation, file), 'r') as pgn:
        pgnContent = pgn.readlines()
        # print(pgnContent[:50])

        for pgnLine in pgnContent:

            if pgnLine[0] == '[':
                savingMoves = False
                    
            elif pgnLine == '\n':
                savingMoves = False
            else:
                splitLine = re.split(r'\s(?=\d)', pgnLine)
                result = []
                for section in splitLine:
                    # print(section)
                    splitSection = re.split(r'(?<=\d)\.', section)
                    if len(splitSection) == 1:
                        temp = splitSection[0].strip().split(' ')
                        if temp == ['1-0'] or temp == ['0-1'] or temp == ['']:
                            pass
                        else:
                            result.append(temp)
                    elif len(splitSection) == 2:
                        result.append(splitSection[1].strip().split(' '))
                    else:
                        pass

                if not savingMoves:
                    pgnJsonObject.append([])

                [pgnJsonObject[-1].append(i) for item in result for i in item if i != '']
                savingMoves = True

    iterCount += 1
    print(f'File Complete {iterCount} out of {len(pgnList)}')


# print(pgnJsonObject)
with open(os.path.join(jsonLocation, jsonFileName), 'w') as file:
    json.dump(pgnJsonObject, file)
            # TODO: Create clause for empty lines and then actual game moves
        
        
        
