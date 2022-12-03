import Foundation

func findSortedCalorieTotal() -> [Int] {
    guard let input = PlaygroundHelper.shared.convertTextFileToString(name: "1-1") else { return [] }
    let linesArray = input.components(separatedBy: "\n")
    let indices = linesArray.enumerated().filter{ $0.element == "" }.map { $0.offset }
    var calorieTotals = [Int]()
    indices.enumerated().forEach { (index, value) in
        if index == 0 {
            let calorieTotal = Array(linesArray[0...value]).compactMap { Int($0) }.reduce(0, +)
            calorieTotals.append(calorieTotal)
        } else {
            let previousIndex = indices[index - 1]
            let calorieTotal = Array(linesArray[previousIndex...value]).compactMap { Int($0) }.reduce(0, +)
            calorieTotals.append(calorieTotal)
        }
    }
    return calorieTotals.sorted()
}

func findMaxCalorie() -> Int {
    return findSortedCalorieTotal().last ?? 0
}

func findTopThreeCalorieTotal() -> Int {
    let calorieTotal = findSortedCalorieTotal()
    return calorieTotal.suffix(3).reduce(0, +)
}

findMaxCalorie()
findTopThreeCalorieTotal()
