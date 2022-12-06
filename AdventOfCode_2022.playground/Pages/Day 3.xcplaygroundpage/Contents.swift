//: [Previous](@previous)

import Foundation

func sumOfDuplicatePriorityItems() -> Int {
    guard let input = PlaygroundHelper.shared.convertTextFileToString(name: "3") else { return 0 }
    let priorityValueDict = makePriorityValueDict()
    let itemsArray = input.components(separatedBy: "\n")
    let prioritySum = itemsArray.map { items in
        let numberOfItems = items.count
        let compartment1 = Set(items.prefix(numberOfItems / 2))
        let compartment2 = Set(items.suffix(numberOfItems / 2))
        let duplicates = compartment1.intersection(compartment2)
        
        let valueOfDuplicates = duplicates.map { duplicate in
            let char: Character = duplicate
            return priorityValueDict[char] ?? 0
        }.reduce(0, +)
        return valueOfDuplicates
    }.reduce(0, +)
    return prioritySum
}

func sumOfPriorityForBadges() -> Int {
    guard let input = PlaygroundHelper.shared.convertTextFileToString(name: "1-3") else { return 0 }
    let priorityValueDict = makePriorityValueDict()
    let itemsArray = input.components(separatedBy: "\n")
    let chunkedItems = itemsArray.chunked(into: 3)
    let prioritySum = chunkedItems.map { chunk in
        let setOne = Set(chunk[0])
        let setTwo = Set(chunk[1])
        let setThree = Set(chunk[2])
        let badges = setOne.intersection(setTwo).intersection(setThree)
        let valueOfBadges = badges.map { badge in
            let char: Character = badge
            return priorityValueDict[char] ?? 0
        }.reduce(0, +)
        return valueOfBadges
    }.reduce(0, +)
    return prioritySum
}

func makePriorityValueDict() -> [Character: Int] {
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    let lowercaseArray = Array(alphabet)
    let uppercaseArray = Array(alphabet.uppercased())
    var dict = [Character: Int]()
    
    lowercaseArray.enumerated().forEach { (index, value) in
        dict[value] = index + 1
    }
    uppercaseArray.enumerated().forEach { (index, value) in
        dict[value] = index + 27
    }
    return dict
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
//sumOfDuplicatePriorityItems()
//sumOfPriorityForBadges()

import XCTest
class SamSpeedTest: XCTestCase {
    func testSumOfDuplicates() {
        self.measure {
            let _ = sumOfDuplicatePriorityItems()
        }
    }
    
//    func testSumOfBadges() {
//        self.measure {
//            let _ = testSumOfBadges()
//        }
//    }
}
SamSpeedTest().run()
//: [Next](@next)
