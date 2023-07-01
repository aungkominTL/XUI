
import SwiftUI

/// Constants that define the number of lines in a masonry view.
public enum WaterfallLines {
    
    /// A variable number of lines.
    ///
    /// This case uses the provided `sizeConstraint` to decide the exact
    /// number of lines.
    case adaptive(sizeConstraint: AdaptiveSizeConstraint)
    
    /// A constant number of lines.
    case fixed(Int)
}


public extension WaterfallLines {
    
    /// A variable number of lines.
    ///
    /// This case uses the provided `minSize` to decide the exact number of
    /// lines.
    static func adaptive(minSize: CGFloat) -> WaterfallLines {
        .adaptive(sizeConstraint: .min(minSize))
    }
    
    /// A variable number of lines.
    ///
    /// This case uses the provided `maxSize` to decide the exact number of
    /// lines.
    static func adaptive(maxSize: CGFloat) -> WaterfallLines {
        .adaptive(sizeConstraint: .max(maxSize))
    }
}


public extension WaterfallLines {
    /// Constants that constrain the bounds of an adaptive line in a masonry
    /// view.
    enum AdaptiveSizeConstraint: Equatable {
        
        /// The minimum size of a line in a given axis.
        case min(CGFloat)
        
        /// The maximum size of a line in a given axis.
        case max(CGFloat)
    }
}
