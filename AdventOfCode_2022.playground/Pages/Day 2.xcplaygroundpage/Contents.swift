//: [Previous](@previous)

import Foundation

enum Move: String {
    case paper
    case rock
    case scissors
    
    init?(string: String) {
        switch string {
        case "A", "X":
            self = .rock
        case "B", "Y":
            self = .paper
        case "C", "Z":
            self = .scissors
        default:
            return nil
        }
    }
    
    var value: Int {
        switch self {
        case .paper:
            return 2
        case .rock:
            return 1
        case .scissors:
            return 3
            
        }
    }
}

enum RoundResult: Int {
    case loss = 0
    case draw = 3
    case win = 6
    
    init?(string: String) {
        switch string {
        case "X":
            self = .loss
        case "Y":
            self = .draw
        case "Z":
            self = .win
        default:
            return nil
        }
    }
}

func pRSRoundOne() -> Int {
    guard let input = PlaygroundHelper.shared.convertTextFileToString(name: "1-2") else { return 0 }
    let cipherArray = input.components(separatedBy: "\n")
    let total = cipherArray.map { cipher  in
        let opponentCipher = String(cipher.prefix(1))
        let myCipher = String(cipher.suffix(1))
        let opponentMove = Move(string: opponentCipher)
        let myMove = Move(string: myCipher)
        let score = tallyRoundOne(opponentMove: opponentMove, myMove: myMove)
        return score
    }.reduce(0, +)
    return total
}

func tallyRoundOne(opponentMove: Move?, myMove: Move?) -> Int {
    let lossValue = RoundResult.loss.rawValue
    let drawValue = RoundResult.draw.rawValue
    let winValue = RoundResult.win.rawValue
    
    let score: Int = {
        guard let opponentMove = opponentMove, let myMove = myMove else {
            return 0
        }
        switch (opponentMove, myMove) {
        case (.paper, .paper), (.rock, .rock), (.scissors, .scissors):
            return drawValue + myMove.value
        case (.paper, .rock), (.rock, .scissors), (.scissors, .paper):
            return lossValue + myMove.value
        case (.paper, .scissors), (.rock, .paper), (.scissors, .rock):
            return winValue + myMove.value
        }
    }()
    return score
}

func pRSRoundTwo() -> Int {
    guard let input = PlaygroundHelper.shared.convertTextFileToString(name: "1-2") else { return 0 }
    let cipherArray = input.components(separatedBy: "\n")
    let total = cipherArray.map { cipher  in
        let opponentCipher = String(cipher.prefix(1))
        let roundCipher = String(cipher.suffix(1))
        let opponentMove = Move(string: opponentCipher)
        let roundResult = RoundResult(string: roundCipher)
        let score = tallyRoundTwo(opponentMove: opponentMove, roundResult: roundResult)
        return score
    }.reduce(0, +)
    return total
}

func tallyRoundTwo(opponentMove: Move?, roundResult: RoundResult?) -> Int {
    let paper = Move.paper.value
    let rock = Move.rock.value
    let scissors = Move.scissors.value

    let score: Int = {
        guard let opponentMove = opponentMove, let roundResult = roundResult else {
            return 0
        }
        switch (roundResult, opponentMove) {
        case (.loss, .paper):
            return roundResult.rawValue + rock
        case (.loss, .rock):
            return roundResult.rawValue + scissors
        case (.loss, .scissors):
            return roundResult.rawValue + paper
        case (.draw, .paper):
            return roundResult.rawValue + paper
        case (.draw, .rock):
            return roundResult.rawValue + rock
        case (.draw, .scissors):
            return roundResult.rawValue + scissors
        case (.win, .paper):
            return roundResult.rawValue + scissors
        case (.win, .rock):
            return roundResult.rawValue + paper
        case (.win, .scissors):
            return roundResult.rawValue + rock
        }
    }()
    return score
}

//pRSRoundOne()
//pRSRoundTwo()

class RockPaperScissors {
    var score: Int = 0
    
    let wins: [String: String] = ["A": "Y",
                                  "B": "Z",
                                  "C": "X"]
    
    let ties: [String: String] = ["A": "X",
                                  "B": "Y",
                                  "C": "Z"]
    
    let shapeScore: [String: Int] = ["X": 1,
                                     "Y": 2,
                                     "Z": 3]
    
    let roundResultScore: [Int: Int] = [0: 6,
                                        1: 3,
                                        2: 0]
    
    func getTotalScore() -> Int {
        
        let input = getPuzzleInput()
        let rounds = splitInputIntoTuples(input: input)
        
        rounds.forEach { round in
            let roundResult = evaluateRoundOutcome(round: round)
            updateScore(round: round, roundResult: roundResult)
        }
        
        return score
    }
    
    func getPuzzleInput() -> String {
        let path = Bundle.main.path(forResource: "PuzzleInput02", ofType: "txt")
        
        var puzzleInput = ""
        
        do {
            puzzleInput = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch {
            print("Issue parsing string.")
        }
        
        return puzzleInput
    }
    
    func splitInputIntoTuples(input: String) -> [(String, String)] {
        let inputWithoutLineBreaks = input.components(separatedBy: "\n")
        
        var rounds: [(String, String)] = []
        
        for round in inputWithoutLineBreaks {
            let firstLetter = round[round.startIndex]
            let secondLetterIndex = round.index(before: round.endIndex)
            let secondLetter = round[secondLetterIndex]
            
            rounds.append((String(firstLetter), String(secondLetter)))
        }
        return rounds
    }
    
    func evaluateRoundOutcome(round: (String, String)) -> Int {
        // 0: Player Wins
        // 1: Tie
        // 2: Player Loses
        if wins[round.0] == round.1 {
            return 0
        } else if ties[round.0] == round.1 {
            return 1
        }
        return 2
    }
    
    func updateScore(round: (String, String), roundResult: Int) {
        let shapeScore = shapeScore[round.1]!
        let roundResultScore = roundResultScore[roundResult]!
        score += (shapeScore + roundResultScore)
    }
}

import XCTest
class SamSpeedTest: XCTestCase {

    func testPerformanceExample() {
        self.measure {
            let _ = pRSRoundOne()
        }
    }
}
SamSpeedTest().run()

class MarcSpeedTest: XCTestCase {

    func testPerformanceExample() {
        self.measure {
            let rps = RockPaperScissors()
            rps.getTotalScore()
        }
    }
}
MarcSpeedTest().run()
//: [Next](@next)
