import Foundation

func findMarker(offset: Int) -> Int {
    let input = PlaygroundHelper.shared.convertTextFileToString(name: "1-6")!
    let startIndex = input.index(input.startIndex, offsetBy: 0)
    let endIndex = input.index(input.startIndex, offsetBy: offset)
    for index in 0...(input.count - offset) {
        let startIndex = input.index(input.startIndex, offsetBy: index)
        let endIndex = input.index(input.startIndex, offsetBy: index + offset)
        let range = startIndex..<endIndex
        let set = Set(input[range])
        if set.count == offset {
            return index + offset
        }
    }
    return 0
}

findMarker(offset: 4)
findMarker(offset: 14)
