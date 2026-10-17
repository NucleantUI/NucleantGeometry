# NucleantGeometry

A Swift package of 2D geometry primitives built on SIMD types for GPU-friendly performance. Provides `Angle`, `Point`, `Size`, `Rect`, `EdgeInsets`, and `UnitPoint` — all generic over floating-point scalar types, all `Sendable`.

Part of the [Nucleant](https://github.com/NucleantUI) framework ecosystem. No dependencies.

## Design

All spatial types are backed by `SIMD2` or `SIMD4` so they map directly to GPU memory layouts and benefit from hardware vector operations. The generic `<Scalar: SIMDScalar & BinaryFloatingPoint>` constraint means every type works with both `Float` (for GPU/render use) and `Double` (for precision-sensitive layout). Convenience aliases (`PointF`, `RectF`, etc.) cover the common cases.

## Types

### `Angle`

Stores a value in radians; exposes a `degrees` computed property. Full arithmetic operator support.

```swift
let a = Angle.degrees(90)
let b = Angle.radians(.pi / 4)
let c = a + b           // Angle(radians: 3π/4)
let d = a * 2           // Angle(degrees: 180)
```

### `Point<Scalar>` / `PointF` / `PointD`

A `typealias` for `SIMD2<Scalar>` with a CGPoint-compatible API layer.

```swift
let p = PointF.point(x: 10, y: 20)
let q = PointF.point(x: 30, y: 40)
let dist = p.distance(to: q)        // Float
let mid  = p.midpoint(to: q)        // PointF(20, 30)
let off  = p.offsetBy(dx: 5, dy: 5) // PointF(15, 25)
```

### `Size<Scalar>` / `SizeF` / `SizeD`

A `typealias` for `SIMD2<Scalar>` — `x` = width, `y` = height.

```swift
let s = SizeF.size(width: 1920, height: 1080)
s.aspectRatio        // 1.777...
s.area               // 2_073_600

let fit  = s.aspectFit(in: .size(width: 800, height: 800))   // 800 × 450
let fill = s.aspectFill(in: .size(width: 800, height: 800))  // 1422 × 800
```

### `Rect<Scalar>` / `RectF` / `RectD`

A `typealias` for `SIMD4<Scalar>` with layout `(x, y, width, height)`.

```swift
let r = RectF.rect(x: 10, y: 10, width: 200, height: 100)

// Edges
r.minX / r.midX / r.maxX   // 10 / 110 / 210
r.minY / r.midY / r.maxY   // 10 / 60  / 110

// Corners
r.topLeft     // PointF(10,  10)
r.bottomRight // PointF(210, 110)
r.center      // PointF(110, 60)

// Hit testing
r.contains(point: PointF(50, 50))   // true
r.intersects(RectF.rect(x: 200, y: 50, width: 50, height: 50))

// Transformations
r.insetBy(dx: 10, dy: 10)           // RectF(20, 20, 180, 80)
r.offsetBy(dx: 5, dy: -5)           // RectF(15, 5, 200, 100)
r.union(RectF.rect(x: 0, y: 0, width: 50, height: 50))
r.intersection(RectF.rect(x: 50, y: 50, width: 200, height: 200))

// Special values
RectF.rectZero
RectF.null      // (.infinity, .infinity, 0, 0) — represents absence
RectF.infinite
```

### `EdgeInsets<Scalar>` / `EdgeInsetsF` / `EdgeInsetsD`

SIMD4-backed inset values `(top, leading, bottom, trailing)`.

```swift
let insets = EdgeInsetsF(top: 8, leading: 16, bottom: 8, trailing: 16)
let padded = EdgeInsetsF(12)                    // all edges = 12
let card   = EdgeInsetsF(horizontal: 16, vertical: 8)

let frame = RectF.rect(x: 0, y: 0, width: 320, height: 60)
let inner = insets.inset(frame)   // shrink rect by insets
let outer = insets.expand(frame)  // grow rect by insets
```

### `UnitPoint`

A normalized `(x, y)` coordinate in `[0, 1]` space, used for anchor points and gradient positions.

```swift
UnitPoint.center        // (0.5, 0.5)
UnitPoint.topLeading    // (0.0, 0.0)
UnitPoint.bottomTrailing // (1.0, 1.0)

// Convert to absolute coords in a frame
let anchor = UnitPoint.center.absolutePoint(in: RectF.rect(x: 0, y: 0, width: 200, height: 100))
// → PointF(100, 50)
```

## Adding to your package

```swift
// Package.swift
.package(path: "../NucleantGeometry"),  // local development
// or: .package(url: "https://github.com/NucleantUI/NucleantGeometry", from: "x.x.x")

// target dependencies
.product(name: "NucleantGeometry", package: "NucleantGeometry"),
```

## License

MIT — see [LICENSE](LICENSE).
