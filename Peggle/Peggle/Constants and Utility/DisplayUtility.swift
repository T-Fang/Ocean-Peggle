//
//  DisplayUtility.swift
//  Peggle
//
//  Created by TFang on 12/2/21.
//

import UIKit
class DisplayUtility {
    static func getPegDimImage(color: PegColor, shape: PegShape) -> UIImage {
        switch shape {
        case .circle:
            switch color {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange")
            case .green:
                return #imageLiteral(resourceName: "peg-green")
            }
        case .triangle:
            switch color {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-triangle")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-triangle")
            case .green:
                return #imageLiteral(resourceName: "peg-green-triangle")
            }
        }
    }

    static func getPegGlowImage(color: PegColor, shape: PegShape) -> UIImage {
        switch shape {
        case .circle:
            switch color {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-glow")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-glow")
            case .green:
                return #imageLiteral(resourceName: "peg-green-glow")
            }
        case .triangle:
            switch color {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-glow-triangle")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-glow-triangle")
            case .green:
                return #imageLiteral(resourceName: "peg-green-glow-triangle")
            }
        }
    }

    private static func getSquareFrame(at center: CGPoint, radius: CGFloat) -> CGRect {
        let origin = center.offsetBy(x: -radius, y: -radius)
        let size = CGSize(width: radius * 2, height: radius * 2)
        let frame = CGRect(origin: origin, size: size)
        return frame
    }
    static func getBubbleImageView(at center: CGPoint) -> UIImageView {

        let bubble = UIImageView(frame: getSquareFrame(at: center,
                                                       radius: Constants.spaceBlastRadius))
        bubble.image = #imageLiteral(resourceName: "soap-bubbles")
        return bubble
    }

    static func getFloatingBubbles() -> UIImageView {
        let floatingBubbles = UIImageView(frame: getSquareFrame(at: .zero, radius: Constants.floatingBubblesRadius))

        floatingBubbles.image = #imageLiteral(resourceName: "float-bubble-icon")
        floatingBubbles.alpha = Constants.alphaForfloatingBubbles
        return floatingBubbles
    }
    static func getPegView(for peg: Peg) -> PegView {
        let pegView = PegView(shape: peg.shape, color: peg.color, unrotatedframe: peg.unrotatedFrame)
        setUpOscillatableView(for: peg, objectView: pegView)

        pegView.transform = pegView.transform.rotated(by: peg.physicsShape.rotation)
        return pegView
    }
    static func getPegView(for gamePeg: GamePeg) -> PegView {
        let pegView = PegView(shape: gamePeg.shape, color: gamePeg.color,
                              unrotatedframe: gamePeg.physicsShape.unrotatedFrame,
                              rotation: gamePeg.physicsShape.rotation)
        if gamePeg.isHit {
            pegView.select()
        }
        return pegView
    }
    static func getBlockView(for block: Block) -> BlockView {
        let blockView = BlockView(unrotatedframe: block.unrotatedFrame)
        setUpOscillatableView(for: block, objectView: blockView)
        blockView.transform = blockView.transform.rotated(by: block.physicsShape.rotation)
        return blockView
    }
    static func getBlockView(for gameBlock: GameBlock) -> BlockView {
        let blockView = BlockView(unrotatedframe: gameBlock.physicsShape.unrotatedFrame,
                                  rotation: gameBlock.physicsShape.rotation)
        return blockView
    }

    static func setUpOscillatableView(for object: Oscillatable,
                                      objectView: OscillatableView) {
        guard let info = object.oscillationInfo else {
            return
        }

        let handleView = DisplayUtility
            .getHandleView(isGoingRightFirst: info.isGoingRightFirst,
                           leftArrowLength: object.leftArrowLength,
                           rightArrowLength: object.rightArrowLength)
        let periodLabel = DisplayUtility.getPeriodLabel(frame: objectView.bounds,
                                                        period: info.period)
        let objectViewBoundsCenter = CGPoint(x: objectView.bounds.midX,
                                             y: objectView.bounds.midY)

        let xOffset = CGVector
            .generateVector(from: object.physicsShape.center, to: object.movementCenter)
            .componentOn(object.vectorTowardRight)
        handleView.center = objectViewBoundsCenter.offsetBy(x: xOffset, y: 0)
        objectView.setUp(handleView: handleView, periodLabel: periodLabel)

    }

    static func getPeriodLabel(frame: CGRect, period: CGFloat) -> UIView {
        let periodLabel = UILabel(frame: frame)
        periodLabel.textAlignment = .center
        periodLabel.text = String(format: "%.1fs", Float(period))
        return periodLabel
    }

    static func getArrowBodyImageView(arrowLength: CGFloat, isGreen: Bool) -> UIImageView {
        let size = CGSize(width: arrowLength,
                          height: Constants.handleWidth)
        let frame = CGRect(origin: .zero, size: size)
        let arrowBody = UIImageView(frame: frame)
        arrowBody.image = isGreen ? #imageLiteral(resourceName: "arrow-body-green") : #imageLiteral(resourceName: "arrow-body-red")
        return arrowBody
    }

    static func getArrowHeadImageView(arrowLength: CGFloat, isGreen: Bool, towardRight: Bool) -> UIImageView {
        let radius = Constants.handleRadius
        let size = CGSize(width: radius * 2, height: radius * 2)
        let frame = CGRect(origin: .zero, size: size)

        let arrowHead = UIImageView(frame: frame)
        arrowHead.image = isGreen ? #imageLiteral(resourceName: "arrow-head-green") : #imageLiteral(resourceName: "arrow-head-red")
        arrowHead.transform = arrowHead.transform
            .rotated(by: CGFloat.pi / 2 * (towardRight ? 1 : -1))
        return arrowHead
    }
    static func getArrowView(arrowLength: CGFloat, isGreen: Bool, towardRight: Bool) -> UIView {
        let radius = Constants.handleRadius
        let size = CGSize(width: arrowLength + radius, height: radius * 2)
        let frame = CGRect(origin: .zero, size: size)
        let arrowView = UIView(frame: frame)

        let arrowHead = getArrowHeadImageView(arrowLength: arrowLength, isGreen: isGreen, towardRight: towardRight)
        let arrowBody = getArrowBodyImageView(arrowLength: arrowLength, isGreen: isGreen)

        arrowView.addSubview(arrowHead)
        arrowView.addSubview(arrowBody)

        if towardRight {
            arrowHead.center = CGPoint(x: arrowLength, y: radius)
            arrowBody.center = CGPoint(x: arrowLength / 2, y: radius)
        } else {
            arrowHead.center = CGPoint(x: radius, y: radius)
            arrowBody.center = CGPoint(x: radius + arrowLength / 2, y: radius)
        }

        return arrowView
    }
    static func getHandleView(isGoingRightFirst: Bool, leftArrowLength: CGFloat,
                              rightArrowLength: CGFloat) -> UIView {
        let radius = Constants.handleRadius

        let width = 2 * radius
            + leftArrowLength + rightArrowLength
        let size = CGSize(width: width, height: 2 * radius)
        let handleView = UIView(frame: CGRect(origin: .zero, size: size))

        let greenHandleLength = isGoingRightFirst ? rightArrowLength : leftArrowLength
        let redHandleLength = isGoingRightFirst ? leftArrowLength : rightArrowLength

        let greenHandle = DisplayUtility
            .getArrowView(arrowLength: greenHandleLength,
                          isGreen: true, towardRight: isGoingRightFirst)
        let redHandle = DisplayUtility
            .getArrowView(arrowLength: redHandleLength,
                          isGreen: false, towardRight: !isGoingRightFirst)

        handleView.addSubview(greenHandle)
        handleView.addSubview(redHandle)

        if isGoingRightFirst {
            redHandle.center = CGPoint(x: (radius + redHandleLength) / 2, y: radius)
            greenHandle.center = CGPoint(x: width - (radius + greenHandleLength) / 2,
                                         y: radius)
        } else {
            greenHandle.center = CGPoint(x: (radius + greenHandleLength) / 2, y: radius)
            redHandle.center = CGPoint(x: width - (radius + redHandleLength) / 2,
                                       y: radius)
        }

        return handleView
    }
}
