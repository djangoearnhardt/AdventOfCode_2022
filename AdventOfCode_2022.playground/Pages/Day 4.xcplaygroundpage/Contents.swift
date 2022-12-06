//: [Previous](@previous)

import Foundation

enum BoundCriteria {
    case fullyContained
    case overlapped
}

func findRedundantWorkCount(criteria: BoundCriteria) -> Int {
    let input = PlaygroundHelper.shared.convertTextFileToString(name: "4")!
    let itemsArray = input.components(separatedBy: "\n")
    let rangesArray = itemsArray.map { $0.components(separatedBy: ",") }
    let redundantWorkCount = rangesArray.map { range in
        let isRedundant = isRedundantWork(criteria: criteria, strings: range)
        return isRedundant ? 1 : 0
    }.reduce(0, +)
    return redundantWorkCount
}

func isRedundantWork(criteria: BoundCriteria, strings: [String]) -> Bool {
    let bounds = strings.map { $0.components(separatedBy: "-") }.flatMap { $0 }.compactMap { Int($0) }
    let rangeOne = bounds[0]...bounds[1]
    let rangeTwo = bounds[2]...bounds[3]
    let isFullyContained = (criteria == .fullyContained && (rangeOne.contains(rangeTwo) || rangeTwo.contains(rangeOne)))
    let isOverlapping = (criteria == .overlapped && (rangeOne.contains(bounds[2]) || rangeTwo.contains(bounds[0])))
    
    return isFullyContained || isOverlapping ? true : false
}

findRedundantWorkCount(criteria: .fullyContained)
findRedundantWorkCount(criteria: .overlapped)
