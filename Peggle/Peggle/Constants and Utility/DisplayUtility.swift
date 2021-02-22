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
        }
    }
    static func generatePegView(for peg: Peg) -> PegView {
        let pegView = PegView(shape: peg.shape, color: peg.color, unrotatedframe: peg.bounds)
        if let handleView = generateHandleView(for: peg),
           let period = peg.oscillationInfo?.period {
            let periodLabel = UILabel(frame: pegView.bounds)
            periodLabel.textAlignment = .center
            periodLabel.text = String(format: "%ds", period)
            pegView.addSubview(periodLabel)
            pegView.addSubview(handleView)
            let centerToMovementCenter = CGVector.generateVector(from: peg.center,
                                                                 to: peg.movementCenter)
            let pegViewBoundsCenter = CGPoint(x: pegView.bounds.midX,
                                              y: pegView.bounds.midY)
            handleView.center = pegViewBoundsCenter.offset(by: centerToMovementCenter)
            pegView.sendSubviewToBack(handleView)
        }
        pegView.transform = pegView.transform.rotated(by: peg.physicsShape.rotation)
        return pegView
    }
    static func generateHandleView(for peg: Peg) -> UIView? {
        guard let info = peg.oscillationInfo else {
            return nil
        }
        return DisplayUtility.getHandleView(isGoingRightFirst: info.isGoingRightFirst,
                                            leftArrowLength: peg.leftArrowLength,
                                            rightArrowLength: peg.rightArrowLength)
    }
    static func getBubbleImageView(at center: CGPoint) -> UIImageView {
        let radius = Constants.spaceBlastRadius
        let origin = center.offsetBy(x: -radius, y: -radius)
        let size = CGSize(width: radius * 2, height: radius * 2)
        let frame = CGRect(origin: origin, size: size)

        let bubble = UIImageView(frame: frame)
        bubble.image = #imageLiteral(resourceName: "soap-bubbles")
        return bubble
    }

    static func getArrowBodyImageView(arrowLength: CGFloat, isGreen: Bool) -> UIImageView {
        let size = CGSize(width: arrowLength,
                          height: Constants.defaultHandleWidth)
        let frame = CGRect(origin: .zero, size: size)
        let arrowBody = UIImageView(frame: frame)
        arrowBody.image = isGreen ? #imageLiteral(resourceName: "arrow-body-green") : #imageLiteral(resourceName: "arrow-body-red")
        return arrowBody
    }

    static func getArrowHeadImageView(arrowLength: CGFloat, isGreen: Bool, towardRight: Bool) -> UIImageView {
        let radius = Constants.defaultHandleRadius
        let size = CGSize(width: radius * 2, height: radius * 2)
        let frame = CGRect(origin: .zero, size: size)

        let arrowHead = UIImageView(frame: frame)
        arrowHead.image = isGreen ? #imageLiteral(resourceName: "arrow-head-green") : #imageLiteral(resourceName: "arrow-head-red")
        arrowHead.transform = arrowHead.transform
            .rotated(by: CGFloat.pi / 2 * (towardRight ? 1 : -1))
        return arrowHead
    }
    static func getArrowView(arrowLength: CGFloat, isGreen: Bool, towardRight: Bool) -> UIView {
        let radius = Constants.defaultHandleRadius
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
        let radius = Constants.defaultHandleRadius

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
