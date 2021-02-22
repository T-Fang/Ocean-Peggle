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
    private(set) var blocks = Set<Block>()
    var levelName: String?

    init(boardSize: CGSize) {
        self.boardSize = boardSize
    }

    convenience init() {
        self.init(boardSize: CGSize(width: Constants.screenWidth, height: Constants.screenWidth))
    }

    /// the number of orange pegs in this level
    var oragnePegCount: Int {
        pegs.filter({ $0.color == .orange }).count
    }

    /// Checks whether there is an orange peg in this level
    var hasOrangePeg: Bool {
        pegs.contains(where: { $0.color == .orange })
    }

    /// Adds a block with the given shape and color at the given position
    /// Constraints: the new block is valid on the game board, otherwise nothing happens
    func addBlock(at position: CGPoint, width: CGFloat, height: CGFloat,
                  isOscillating: Bool = false) {
        let newBlock = Block(size: CGSize(width: width, height: height),
                             center: position, isOscillating: isOscillating)

        if isObjectValidOnBoard(object: newBlock) {
            blocks.insert(newBlock)
        }
    }

    /// Adds a peg with the given shape and color at the given position
    /// Constraints: the new peg is valid on the game board, otherwise nothing happens
    func addPeg(at position: CGPoint, shape: PegShape, color: PegColor,
                isOscillating: Bool = false) {
        let newPeg = Peg(circlePegOfCenter: position, color: color, isOscillating: isOscillating)

        if isObjectValidOnBoard(object: newPeg) {
            pegs.insert(newPeg)
        }
    }

    /// Removes the object at the given position
    /// Constraints: the position must lie inside one of the object's area, otherwise nothing happens
    func removePeg(at position: CGPoint) {
        guard let object = getObjectThatContains(position) else {
            return
        }
        remove(object)
    }

    func getObjectThatContains(_ point: CGPoint) -> PeggleObject? {
        let peg = pegs.first(where: { $0.contains(point) })
        return peg == nil ? blocks.first(where: { $0.contains(point) }) : peg
    }

    func modify(object: PeggleObject, by modification: (PeggleObject) -> PeggleObject) -> PeggleObject? {
        guard contains(object) else {
            return nil
        }
        remove(object)

        let newObject = modification(object)

        guard isObjectValidOnBoard(object: newObject) else {
            add(object)
            return nil
        }

        add(newObject)
        return newObject
    }
    /// Moves the object to the `newPosition`
    /// - Returns the new object if the object is successfully moved, and nil otherwise
    func moveObject(_ object: PeggleObject, to newPosition: CGPoint) -> PeggleObject? {
        modify(object: object, by: { $0.moveTo(newPosition) })
    }

    /// Resizes the given `object`. if the scale is negative, the `object` is unchanged
    /// - Returns: the new object if the new object has a valid size and is valid on board, and nil otherwise
    func resizeObject(_ object: PeggleObject, by scale: CGFloat) -> PeggleObject? {
        modify(object: object, by: { $0.resize(by: scale) })
    }

    func resetPegBoard() {
        pegs = []
        blocks = []
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

    private func add(_ object: PeggleObject) {
        if let peg = object as? Peg {
            pegs.insert(peg)
        }
        if let block = object as? Block {
            blocks.insert(block)
        }
    }
    private func remove(_ object: PeggleObject) {
        if let peg = object as? Peg {
            pegs.remove(peg)
        }
        if let block = object as? Block {
            blocks.remove(block)
        }
    }
    private func contains(_ object: PeggleObject) -> Bool {
        if let peg = object as? Peg {
            return pegs.contains(peg)
        }
        if let block = object as? Block {
            return blocks.contains(block)
        }
        return false
    }

    /// Checks whether the given object lies inside the boundary of the game board
    /// and does not overlap with other objects
    private func isObjectValidOnBoard(object: PeggleObject) -> Bool {
        isWithinBoundary(object: object)
            && isSizeValid(object: object)
            && pegs.allSatisfy({ !$0.overlaps(with: object) })
            && blocks.allSatisfy({ !$0.overlaps(with: object) })
    }

    /// Checks whether the given object lies inside the boundary of the game board
    private func isWithinBoundary(object: Oscillatable) -> Bool {
        let frame = object.areaShape.frame
        return frame.minX >= 0 && frame.maxX <= boardSize.width
            && frame.minY >= 0 && frame.maxY <= boardSize.height
    }
    private func isSizeValid(object: PeggleObject) -> Bool {
        if let peg = object as? Peg {
            return isSizeValid(peg: peg)
        }
        if let block = object as? Block {
            return isSizeValid(block: block)
        }
        return false
    }
    private func isSizeValid(peg: Peg) -> Bool {
        let physicsShape = peg.physicsShape
        switch physicsShape.shape {
        case .circle:
            return physicsShape.radius >= Constants.minCirclePegRadius
                && physicsShape.radius <= Constants.maxCirclePegRadius
        case .rectangle:
            return false
        }
    }
    private func isSizeValid(block: Block) -> Bool {
        let width = block.physicsShape.width
        let height = block.physicsShape.height
        return width >= Constants.minBlockWidth && width <= Constants.maxBlockWidth
            && height >= Constants.minBlockHeight && height <= Constants.maxBlockHeight
    }
}
