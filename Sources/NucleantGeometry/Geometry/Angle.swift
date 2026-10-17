import Foundation

/// Represents an angle measurement
public struct Angle: Sendable, Hashable {
    /// The angle value in radians
    public var radians: Double
    
    /// The angle value in degrees
    public var degrees: Double {
        get { radians * 180 / .pi }
        set { radians = newValue * .pi / 180 }
    }
    
    /// Creates an angle from radians
    public init(radians: Double) {
        self.radians = radians
    }
    
    /// Creates an angle from degrees
    public init(degrees: Double) {
        self.radians = degrees * .pi / 180
    }
    
    /// Creates an angle of zero
    public static var zero: Angle {
        Angle(radians: 0)
    }
    
    /// Creates an angle from radians
    public static func radians(_ radians: Double) -> Angle {
        Angle(radians: radians)
    }
    
    /// Creates an angle from degrees
    public static func degrees(_ degrees: Double) -> Angle {
        Angle(degrees: degrees)
    }
}

// MARK: - Arithmetic

extension Angle {
    public static func + (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians + rhs.radians)
    }
    
    public static func - (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians - rhs.radians)
    }
    
    public static func * (lhs: Angle, rhs: Double) -> Angle {
        Angle(radians: lhs.radians * rhs)
    }
    
    public static func * (lhs: Double, rhs: Angle) -> Angle {
        Angle(radians: lhs * rhs.radians)
    }
    
    public static func / (lhs: Angle, rhs: Double) -> Angle {
        Angle(radians: lhs.radians / rhs)
    }
    
    public prefix static func - (angle: Angle) -> Angle {
        Angle(radians: -angle.radians)
    }
}
