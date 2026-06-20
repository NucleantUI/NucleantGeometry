import simd

/// A 2D size using SIMD for performance
///
/// Compatible with CGSize-like API while using SIMD2 internally.
/// Uses x for width and y for height.
public typealias Size<Scalar: SIMDScalar & BinaryFloatingPoint> = SIMD2<Scalar>

extension SIMD2 where Scalar: BinaryFloatingPoint {
    /// The width (x component)
    @inlinable
    public var width: Scalar {
        get { x }
        set { x = newValue }
    }
    
    /// The height (y component)
    @inlinable
    public var height: Scalar {
        get { y }
        set { y = newValue }
    }
    
    /// Creates a size with the specified dimensions
    @inlinable
    public static func size(width: Scalar, height: Scalar) -> Self {
        Self(width, height)
    }
    
    /// The zero size (0, 0)
    @inlinable
    public static var sizeZero: Self {
        Self.zero
    }
    
    /// Area of the size (width * height)
    @inlinable
    public var area: Scalar {
        width * height
    }
    
    /// Aspect ratio (width / height)
    @inlinable
    public var aspectRatio: Scalar {
        guard height != 0 else { return 0 }
        return width / height
    }
    
    /// Returns a size scaled by the given factors
    @inlinable
    public func scaledBy(sx: Scalar, sy: Scalar) -> Self {
        Self(width * sx, height * sy)
    }
    
    /// Returns a size scaled uniformly
    @inlinable
    public func scaledBy(_ scale: Scalar) -> Self {
        self * scale
    }
    
    /// Returns a size fitting within the target while maintaining aspect ratio
    @inlinable
    public func aspectFit(in target: Self) -> Self {
        let scale = Swift.min(target.width / width, target.height / height)
        return scaledBy(scale)
    }
    
    /// Returns a size filling the target while maintaining aspect ratio
    @inlinable
    public func aspectFill(in target: Self) -> Self {
        let scale = Swift.max(target.width / width, target.height / height)
        return scaledBy(scale)
    }
}

/// Float-based size alias
public typealias SizeF = Size<Float>

/// Double-based size alias
public typealias SizeD = Size<Double>
