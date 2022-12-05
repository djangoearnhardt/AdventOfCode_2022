//: [Previous](@previous)

import Foundation

func getTopOfStacks(dict: [Int: [String]]) -> String {
    var topOfStacks = ""
    for index in 1...9 {
        topOfStacks += dict[index]?.last ?? ""
    }
    return topOfStacks
}

func makeCrateDict(stackArray: [String]) -> [Int: [String]] {
    var horizontalCrateDictionary = [Int: [String]]()
    let stackStrings = stackArray.map { array in
        return array.enumerated().compactMap({ ($0 > 0) && ($0 % 4 == 0) ? ":\($1)" : "\($1)" }).joined().split(separator: ":").map { String($0) }
    }
    let stackStringsCleaned = stackStrings.map { array in
        return array.map { cleanBrackets(string: $0)}
    }
    stackStringsCleaned.enumerated().forEach { (stackIndex, stackStrings) in
        stackStrings.enumerated().forEach { (stringIndex, stringValue) in
                var stackArray = horizontalCrateDictionary[stackIndex] ?? []
                stackArray.append(stringValue)
                horizontalCrateDictionary[stackIndex] = stackArray
        }
    }
    var verticalCrateDictionary = [Int: [String]]()
    for xIndex in 0..<9 {
        var array = [String]()
        var yIndex = 0
        while yIndex <= 7  {
            if let crateString = horizontalCrateDictionary[yIndex]?[xIndex], !crateString.isEmpty {
                array.append(crateString)
                yIndex += 1
            } else {
                break
            }
        }
        verticalCrateDictionary[xIndex + 1] = array
    }
    return verticalCrateDictionary
}

func cleanBrackets(string: String) -> String {
    if string.isEmpty {
        return ""
    } else {
        var cleanedString = string
        let removeCharacters: Set<Character> = ["[", "]", " "]
        cleanedString.removeAll(where: { removeCharacters.contains($0) } )
        return cleanedString
    }
}

func numberOfMovesFromArrayToArray(string: String) -> (Int?, (Int?, Int?)) {
    let directions = string.replacingOccurrences(of: "move ", with: "")
        .replacingOccurrences(of: "from ", with: "")
        .replacingOccurrences(of: "to ", with: "")
        .replacingOccurrences(of: " ", with: ":")
        .split(separator: ":")
        .map { Int($0) }
    return (directions[0], (directions[1], directions[2]))
}

func makeCratesAndDirections() -> ([String], [String]) {
    let input = PlaygroundHelper.shared.convertTextFileToString(name: "1-5")!
    var itemsArray = input.components(separatedBy: "\n")
    let crateArray = Array(itemsArray[0...7])
    itemsArray.removeSubrange(0...9)
    return (crateArray, itemsArray)
}

func crateMover9000() {
    let (crates, directions) = makeCratesAndDirections()
    var stackDict = makeCrateDict(stackArray: crates.reversed())
    directions.forEach { direction in
        let (moves, (from, to)) = numberOfMovesFromArrayToArray(string: direction)
        if let moves = moves, let from = from, let to = to {
            for _ in 1...moves {
                if let itemToMove = stackDict[from]?.last {
                    var fromArray = stackDict[from]
                    fromArray?.removeLast()
                    var toArray = stackDict[to]
                    toArray?.append(itemToMove)
                    stackDict[from] = fromArray
                    stackDict[to] = toArray
                }
            }
        }
    }
    getTopOfStacks(dict: stackDict)
}

func crateMover9001() {
    let (crates, directions) = makeCratesAndDirections()
    var stackDict = makeCrateDict(stackArray: crates.reversed())
    directions.forEach { direction in
        let (moves, (from, to)) = numberOfMovesFromArrayToArray(string: direction)
        if let moves = moves, let from = from, let to = to {
            var groupOfCrates = [String]()
            for _ in 1...moves {
                if let itemToMove = stackDict[from]?.last {
                    var fromArray = stackDict[from]
                    groupOfCrates.append(itemToMove)
                    fromArray?.removeLast()
                    stackDict[from] = fromArray
                }
            }
            if var toArray = stackDict[to] {
                toArray += groupOfCrates.reversed()
                stackDict[to] = toArray
            }
        }
    }
    getTopOfStacks(dict: stackDict)
}

//crateMover9000()
crateMover9001()
