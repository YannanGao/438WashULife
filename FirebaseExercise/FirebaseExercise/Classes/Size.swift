

import UIKit


public enum Dimension {
    case absolute(_ dimension: CGFloat)
    case frational(_ multiplier: CGFloat)
    case fill
    
    public func getValue(_ dimen: CGFloat) -> CGFloat {
        switch self {
        case .absolute(let constant): return constant
        case .frational(let mult): return mult * dimen
        case .fill: return dimen
        }
    }
}


public struct Size {
    static let identity = Size(width: .fill, height: .fill)
    
    public let width: Dimension
    public let height: Dimension
    
    public init(width: Dimension, height: Dimension) {
        self.width = width
        self.height = height
    }
    
    public func getTransformed(size: CGSize) -> CGSize {
        return CGSize(
            width: width.getValue(size.width),
            height: height.getValue(size.height)
        )
    }
}
