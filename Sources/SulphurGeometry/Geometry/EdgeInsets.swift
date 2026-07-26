import simd

/// Edge insets for padding and margins
///
/// Uses SIMD4 internally: (top, leading, bottom, trailing)
public struct EdgeInsets<Scalar: SIMDScalar & BinaryFloatingPoint & Sendable>: Equatable, Sendable where Scalar.SIMD4Storage: Sendable {
    /// Internal SIMD storage: (top, leading, bottom, trailing)
    public var storage: SIMD4<Scalar>
    
    /// Top inset
    @inlinable public var top: Scalar {
        get { storage.x }
        set { storage.x = newValue }
    }
    
    /// Leading (left in LTR) inset
    @inlinable public var leading: Scalar {
        get { storage.y }
        set { storage.y = newValue }
    }
    
    /// Bottom inset
    @inlinable public var bottom: Scalar {
        get { storage.z }
        set { storage.z = newValue }
    }
    
    /// Trailing (right in LTR) inset
    @inlinable public var trailing: Scalar {
        get { storage.w }
        set { storage.w = newValue }
    }
    
    // MARK: - Initializers
    
    /// Creates edge insets with individual values
    @inlinable
    public init(top: Scalar, leading: Scalar, bottom: Scalar, trailing: Scalar) {
        self.storage = SIMD4(top, leading, bottom, trailing)
    }
    
    /// Creates edge insets with the same value on all edges
    @inlinable
    public init(_ all: Scalar) {
        self.storage = SIMD4(repeating: all)
    }
    
    /// Creates edge insets with horizontal and vertical values
    @inlinable
    public init(horizontal: Scalar, vertical: Scalar) {
        self.storage = SIMD4(vertical, horizontal, vertical, horizontal)
    }
    
    /// Zero insets
    @inlinable
    public static var zero: EdgeInsets {
        EdgeInsets(0)
    }
    
    // MARK: - Computed Properties
    
    /// Total horizontal insets (leading + trailing)
    @inlinable
    public var horizontal: Scalar {
        leading + trailing
    }
    
    /// Total vertical insets (top + bottom)
    @inlinable
    public var vertical: Scalar {
        top + bottom
    }
    
    // MARK: - Operations
    
    /// Apply insets to a rect (shrink it)
    @inlinable
    public func inset(_ rect: Rect<Scalar>) -> Rect<Scalar> {
        Rect.rect(
            x: rect.originX + leading,
            y: rect.originY + top,
            width: rect.rectWidth - horizontal,
            height: rect.rectHeight - vertical
        )
    }
    
    /// Expand a rect by these insets
    @inlinable
    public func expand(_ rect: Rect<Scalar>) -> Rect<Scalar> {
        Rect.rect(
            x: rect.originX - leading,
            y: rect.originY - top,
            width: rect.rectWidth + horizontal,
            height: rect.rectHeight + vertical
        )
    }
}

/// Float-based edge insets
public typealias EdgeInsetsF = EdgeInsets<Float>

/// Double-based edge insets
public typealias EdgeInsetsD = EdgeInsets<Double>
