import simd

/// A point in 2D space using SIMD for performance
///
/// Compatible with CGPoint-like API while using SIMD2 internally.
/// Supports any BinaryFloatingPoint scalar type.
public typealias Point<Scalar: SIMDScalar & BinaryFloatingPoint> = SIMD2<Scalar>

extension SIMD2 where Scalar: BinaryFloatingPoint {
    /// The x coordinate
    @inlinable
    public var pointX: Scalar {
        get { x }
        set { x = newValue }
    }
    
    /// The y coordinate
    @inlinable
    public var pointY: Scalar {
        get { y }
        set { y = newValue }
    }
    
    /// Creates a point with the specified coordinates
    @inlinable
    public static func point(x: Scalar, y: Scalar) -> Self {
        Self(x, y)
    }
    
    /// The zero point (0, 0)
    @inlinable
    public static var pointZero: Self {
        Self.zero
    }
    
    /// Distance to another point
    @inlinable
    public func distance(to other: Self) -> Scalar {
        let diff = self - other
        return (diff.x * diff.x + diff.y * diff.y).squareRoot()
    }
    
    /// Midpoint between this point and another
    @inlinable
    public func midpoint(to other: Self) -> Self {
        (self + other) / Scalar(2)
    }
    
    /// Returns a point offset by dx and dy
    @inlinable
    public func offsetBy(dx: Scalar, dy: Scalar) -> Self {
        Self(x + dx, y + dy)
    }
}

/// Float-based point alias
public typealias PointF = Point<Float>

/// Double-based point alias  
public typealias PointD = Point<Double>
