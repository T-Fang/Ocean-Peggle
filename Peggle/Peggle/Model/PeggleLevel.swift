//
//  PeggleLevel.swift
//  Peggle
//
//  Created by TFang on 27/1/21.
//

import CoreGraphics

class PeggleLevel: Codable {
    private(set) var boardSize: CGSize
    private(set) var pegs = Set<Peg>()
    var levelName: String?

    init(boardSize: CGSize) {
        self.boardSize = boardSize
    }

    convenience init() {
        self.init(boardSize: CGSize(width: Constants.screenWidth, height: Constants.screenWidth))
    }

    func addBlock(at position: CGPoint, width: CGFloat, height: CGFloat) {

    }
    /// Adds a peg with the given shape and color at the given position
    /// Constraints: the new peg is valid on the game board, otherwise nothing happens
    func addPeg(at position: CGPoint, shape: PegShape, color: PegColor) {
        let newPeg = Peg(circlePegOfCenter: position, color: color)

        if isPegValidOnBoard(peg: newPeg) {
            pegs.insert(newPeg)
        }
    }

    /// Removes the peg at the given position
    /// Constraints: the position must lie inside one of the peg's area, otherwise nothing happens
    func removePeg(at position: CGPoint) {
        guard let peg = getPegThatContains(position) else {
            return
        }
        pegs.remove(peg)
    }

    func getPegThatContains(_ point: CGPoint) -> Peg? {
        pegs.first(where: { $0.contains(point) })
    }

    /// Moves the peg at the `oldPosition` to the `newPosition`
    /// - Returns the new peg if the peg is successfully moved, and nil otherwise
    func movePeg(from oldPosition: CGPoint, to newPosition: CGPoint) -> Peg? {
        guard let oldPeg = getPegThatContains(oldPosition) else {
            return nil
        }
        pegs.remove(oldPeg)

        let newPeg = oldPeg.moveTo(newPosition)

        guard isPegValidOnBoard(peg: newPeg) else {
            pegs.insert(oldPeg)
            return nil
        }

        pegs.insert(newPeg)
        return newPeg
    }

    /// Resizes the given `Peg`. if the scale is negative, the `Peg` is unchanged
    /// - Returns: the new peg if the new peg has a valid size and is valid on board, and nil otherwise
    func resizePeg(peg: Peg, by scale: CGFloat) -> Peg? {
        guard pegs.contains(peg) else {
            return nil
        }
        pegs.remove(peg)

        let newPeg = peg.resize(by: scale)

        guard isPegValidOnBoard(peg: newPeg) && isPegSizeValid(peg: newPeg) else {
            pegs.insert(peg)
            return nil
        }

        pegs.insert(newPeg)
        return newPeg
    }

    private func isPegSizeValid(peg: Peg) -> Bool {
        let physicsShape = peg.physicsShape
        switch physicsShape.shape {
        case .circle:
            return physicsShape.radius >= Constants.minCirclePegRadius
                && physicsShape.radius <= Constants.maxCirclePegRadius
        case .rectangle:
            return false
        }
    }

    func resetPegBoard() {
        pegs = []
    }

    /// - Returns: a nested dictionary containing the numbers of pegs of different shapes and colors.
    func getPegCounts() -> [PegShape: [PegColor: Int]] {
        var pegCounts: [PegShape: [PegColor: Int]] = [:]

        for shape in PegShape.allCases {
            pegCounts[shape] = [:]
            let pegsWithShape = pegs.filter({ $0.shape == shape })
            for color in PegColor.allCases {
                let colorCount = pegsWithShape.filter({ $0.color == color }).count
                pegCounts[shape]?[color] = colorCount
            }
        }

        return pegCounts
    }

    /// - Returns: the number of orange pegs in this level
    func getOragnePegCount() -> Int {
        pegs.filter({ $0.color == .orange }).count
    }

    /// Checks whether there is an orange peg in this level
    func hasOrangePeg() -> Bool {
        pegs.contains(where: { $0.color == .orange })
    }

    /// Checks whether there is an green peg in this level
    func hasGreenPeg() -> Bool {
        pegs.contains(where: { $0.color == .green })
    }

    /// Checks whether the given peg lies inside the boundary of the game board and does not overlap with other pegs
    private func isPegValidOnBoard(peg: Peg) -> Bool {
        isPegWithinBoundary(peg: peg)
            && pegs.allSatisfy({ !$0.overlaps(with: peg) })
    }

    /// Checks whether the given peg lies inside the boundary of the game board
    private func isPegWithinBoundary(peg: Peg) -> Bool {
        let frame = peg.frame
        return frame.minX >= 0 && frame.maxX <= boardSize.width
            && frame.minY >= 0 && frame.maxY <= boardSize.height
    }

}
