/// A point in a view's coordinate space, normalized to 0-1 range
///
/// Used for specifying anchor points for transformations
public struct UnitPoint: Sendable, Hashable {
    /// The x-coordinate (0 = leading, 1 = trailing)
    public var x: Float
    
    /// The y-coordinate (0 = top, 1 = bottom)
    public var y: Float
    
    /// Creates a unit point with the specified coordinates
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    // MARK: - Standard Points
    
    /// The top-leading corner (0, 0)
    public static var topLeading: UnitPoint {
        UnitPoint(x: 0, y: 0)
    }
    
    /// The top center (0.5, 0)
    public static var top: UnitPoint {
        UnitPoint(x: 0.5, y: 0)
    }
    
    /// The top-trailing corner (1, 0)
    public static var topTrailing: UnitPoint {
        UnitPoint(x: 1, y: 0)
    }
    
    /// The leading center (0, 0.5)
    public static var leading: UnitPoint {
        UnitPoint(x: 0, y: 0.5)
    }
    
    /// The center (0.5, 0.5)
    public static var center: UnitPoint {
        UnitPoint(x: 0.5, y: 0.5)
    }
    
    /// The trailing center (1, 0.5)
    public static var trailing: UnitPoint {
        UnitPoint(x: 1, y: 0.5)
    }
    
    /// The bottom-leading corner (0, 1)
    public static var bottomLeading: UnitPoint {
        UnitPoint(x: 0, y: 1)
    }
    
    /// The bottom center (0.5, 1)
    public static var bottom: UnitPoint {
        UnitPoint(x: 0.5, y: 1)
    }
    
    /// The bottom-trailing corner (1, 1)
    public static var bottomTrailing: UnitPoint {
        UnitPoint(x: 1, y: 1)
    }
    
    /// Zero point (0, 0)
    public static var zero: UnitPoint {
        UnitPoint(x: 0, y: 0)
    }
}

extension UnitPoint {
    /// Converts this unit point to an absolute point in the given frame
    public func absolutePoint(in frame: RectF) -> PointF {
        PointF(
            x: frame.originX + frame.rectWidth * x,
            y: frame.originY + frame.rectHeight * y
        )
    }
}
