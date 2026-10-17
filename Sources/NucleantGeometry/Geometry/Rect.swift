// import simd — SIMD4/SIMDScalar are Swift-stdlib builtins now; unneeded
// unless/until this file starts using simd's math ops.

/// A rectangle in 2D space using SIMD4 for performance
///
/// Compatible with CGRect-like API while using SIMD4 internally.
/// Layout: (x, y, width, height)
public typealias Rect<Scalar: SIMDScalar & BinaryFloatingPoint> = SIMD4<Scalar>

extension SIMD4 where Scalar: BinaryFloatingPoint {
    // MARK: - Basic Properties
    
    /// The origin x coordinate
    @inlinable public var originX: Scalar {
        get { x }
        set { x = newValue }
    }
    
    /// The origin y coordinate
    @inlinable public var originY: Scalar {
        get { y }
        set { y = newValue }
    }
    
    /// The width
    @inlinable public var rectWidth: Scalar {
        get { z }
        set { z = newValue }
    }
    
    /// The height
    @inlinable public var rectHeight: Scalar {
        get { w }
        set { w = newValue }
    }
    
    // MARK: - Origin and Size
    
    /// The origin point (x, y)
    @inlinable public var origin: SIMD2<Scalar> {
        get { SIMD2(x, y) }
        set { x = newValue.x; y = newValue.y }
    }
    
    /// The size (width, height)
    @inlinable public var rectSize: SIMD2<Scalar> {
        get { SIMD2(z, w) }
        set { z = newValue.x; w = newValue.y }
    }
    
    // MARK: - Edge Coordinates
    
    /// Minimum X value (left edge)
    @inlinable public var minX: Scalar { x }
    
    /// Middle X value
    @inlinable public var midX: Scalar { x + z / Scalar(2) }
    
    /// Maximum X value (right edge)
    @inlinable public var maxX: Scalar { x + z }
    
    /// Minimum Y value (top edge)
    @inlinable public var minY: Scalar { y }
    
    /// Middle Y value
    @inlinable public var midY: Scalar { y + w / Scalar(2) }
    
    /// Maximum Y value (bottom edge)
    @inlinable public var maxY: Scalar { y + w }
    
    // MARK: - Factory Methods
    
    /// Creates a rect with origin and size
    @inlinable
    public static func rect(x: Scalar, y: Scalar, width: Scalar, height: Scalar) -> Self {
        Self(x, y, width, height)
    }
    
    /// Creates a rect from origin point and size
    @inlinable
    public static func rect(origin: SIMD2<Scalar>, size: SIMD2<Scalar>) -> Self {
        Self(origin.x, origin.y, size.x, size.y)
    }
    
    /// The zero rect
    @inlinable public static var rectZero: Self { Self.zero }
    
    /// The null rect (represents absence of a rect)
    @inlinable public static var null: Self { 
        Self(.infinity, .infinity, 0, 0) 
    }
    
    /// The infinite rect
    @inlinable public static var infinite: Self {
        Self(-.infinity, -.infinity, .infinity, .infinity)
    }
    
    // MARK: - Computed Points
    
    /// Center point of the rect
    @inlinable public var center: SIMD2<Scalar> {
        SIMD2(midX, midY)
    }
    
    /// Top-left corner
    @inlinable public var topLeft: SIMD2<Scalar> {
        SIMD2(minX, minY)
    }
    
    /// Top-right corner
    @inlinable public var topRight: SIMD2<Scalar> {
        SIMD2(maxX, minY)
    }
    
    /// Bottom-left corner
    @inlinable public var bottomLeft: SIMD2<Scalar> {
        SIMD2(minX, maxY)
    }
    
    /// Bottom-right corner
    @inlinable public var bottomRight: SIMD2<Scalar> {
        SIMD2(maxX, maxY)
    }
    
    // MARK: - Queries
    
    /// Whether the rect has zero area
    @inlinable public var isEmpty: Bool {
        z <= 0 || w <= 0
    }
    
    /// Whether this rect is null
    @inlinable public var isNull: Bool {
        x == .infinity
    }
    
    /// Whether this rect is infinite
    @inlinable public var isInfinite: Bool {
        x == -.infinity && y == -.infinity && z == .infinity && w == .infinity
    }
    
    /// Area of the rect
    @inlinable public var rectArea: Scalar {
        z * w
    }
    
    // MARK: - Hit Testing
    
    /// Tests if a point is inside the rect
    @inlinable
    public func contains(point: SIMD2<Scalar>) -> Bool {
        point.x >= minX && point.x < maxX && point.y >= minY && point.y < maxY
    }
    
    /// Tests if another rect is fully contained in this rect
    @inlinable
    public func contains(rect other: Self) -> Bool {
        other.minX >= minX && other.maxX <= maxX &&
        other.minY >= minY && other.maxY <= maxY
    }
    
    /// Tests if two rects intersect
    @inlinable
    public func intersects(_ other: Self) -> Bool {
        minX < other.maxX && maxX > other.minX &&
        minY < other.maxY && maxY > other.minY
    }
    
    // MARK: - Transformations
    
    /// Returns a rect inset by the given amounts
    @inlinable
    public func insetBy(dx: Scalar, dy: Scalar) -> Self {
        Self.rect(x: x + dx, y: y + dy, width: z - dx * 2, height: w - dy * 2)
    }
    
    /// Returns a rect offset by the given amounts
    @inlinable
    public func offsetBy(dx: Scalar, dy: Scalar) -> Self {
        Self.rect(x: x + dx, y: y + dy, width: z, height: w)
    }
    
    /// Returns the intersection of two rects
    @inlinable
    public func intersection(_ other: Self) -> Self {
        let x1 = Swift.max(minX, other.minX)
        let y1 = Swift.max(minY, other.minY)
        let x2 = Swift.min(maxX, other.maxX)
        let y2 = Swift.min(maxY, other.maxY)
        
        if x2 <= x1 || y2 <= y1 {
            return .null
        }
        
        return Self.rect(x: x1, y: y1, width: x2 - x1, height: y2 - y1)
    }
    
    /// Returns the smallest rect containing both rects
    @inlinable
    public func union(_ other: Self) -> Self {
        if isNull { return other }
        if other.isNull { return self }
        
        let x1 = Swift.min(minX, other.minX)
        let y1 = Swift.min(minY, other.minY)
        let x2 = Swift.max(maxX, other.maxX)
        let y2 = Swift.max(maxY, other.maxY)
        
        return Self.rect(x: x1, y: y1, width: x2 - x1, height: y2 - y1)
    }
    
    /// Standardizes the rect (ensures positive width/height)
    @inlinable
    public var standardized: Self {
        var result = self
        if z < 0 {
            result.x += z
            result.z = -z
        }
        if w < 0 {
            result.y += w
            result.w = -w
        }
        return result
    }
    
    /// Returns an integral rect (rounds to integers)
    @inlinable
    public var integral: Self {
        Self.rect(
            x: x.rounded(.down),
            y: y.rounded(.down),
            width: (x + z).rounded(.up) - x.rounded(.down),
            height: (y + w).rounded(.up) - y.rounded(.down)
        )
    }
}

/// Float-based rect alias
public typealias RectF = Rect<Float>

/// Double-based rect alias
public typealias RectD = Rect<Double>
