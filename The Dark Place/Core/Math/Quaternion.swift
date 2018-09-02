import simd

public class Quaternion {
    
    private var position = float4(0)
    public var x: Float {
        get {
            return position.x
        }
        set {
            self.position.x = newValue
        }
    }
    public var y: Float {
        get {
            return position.y
        }
        set {
            self.position.y = newValue
        }
    }
    public var z: Float {
        get {
            return position.z
        }
        set {
            self.position.z = newValue
        }
    }
    public var w: Float {
        get {
            return position.w
        }
        set {
            self.position.w = newValue
        }
    }
    
    public init(position: float4){
        self.position = position
    }
    
    public func normalize(){
        let mag: Float = sqrt(w * w + x * x + y * y + z * z)
        position /= mag
    }
    
    public func toRotationMatrix()->matrix_float4x4{
        var matrix = matrix_identity_float4x4
        let x = position.x
        let y = position.y
        let z = position.z
        let w = position.w
        
        let xy: Float = x * y
        let xz: Float = x * z
        let xw: Float = x * w
        let yz: Float = y * z
        let yw: Float = y * w
        let zw: Float = z * w
        let xSquared: Float = x * x
        let ySquared: Float = y * y
        let zSquared: Float = z * z
        
        matrix.columns = (
            float4(1 - 2 * (ySquared + zSquared), 2 * (xy + zw), 2 * (xz - yw), 0),
            float4(2 * (xy - zw), 1 - 2 * (xSquared + zSquared), 2 * (yz + xw), 0),
            float4(2 * (xz + yw), 2 * (yz - xw), 1 - 2 * (xSquared + ySquared), 0),
            float4(0, 0, 0, 1)
        )
        return matrix
    }
    
    public static func fromMatrix(matrix: matrix_float4x4)->Quaternion{
        var x: Float = 0
        var y: Float = 0
        var z: Float = 0
        var w: Float = 0
        
        let m00 = matrix.columns.0.x
        let m10 = matrix.columns.0.y
        let m20 = matrix.columns.0.z

        let m01 = matrix.columns.1.x
        let m11 = matrix.columns.1.y
        let m21 = matrix.columns.1.z
        
        let m02 = matrix.columns.2.x
        let m12 = matrix.columns.2.y
        let m22 = matrix.columns.2.z
        
        let diagonal = m00 +  m11 + m22

        if (diagonal > 0) {
            let w4 = sqrt(diagonal + 1.0) * 2.0
            w = w4 / 4.0
            x = (m21 - m12) / w4
            y = (m02 - m20) / w4
            z = (m10 - m01) / w4
        } else if ((m00 > m11) && (m00 > m22)) {
            let x4 = sqrt(1.0 + m00 - m11 - m22) * 2.0
            w = (m21 - m12) / x4
            x = x4 / 4.0
            y = (m01 + m10) / x4
            z = (m02 + m20) / x4
        } else if (m11 > m22) {
            let y4 = sqrt(1.0 + m11 - m00 - m22) * 2.0
            w = (m02 - m20) / y4
            x = (m01 + m10) / y4
            y = y4 / 4.0
            z = (m12 + m21) / y4
        } else {
            let z4 = sqrt(1.0 + m22 - m00 - m11) * 2.0
            w = (m10 - m01) / z4
            x = (m02 + m20) / z4
            y = (m12 + m21) / z4
            z = z4 / 4.0
        }
        
        return Quaternion(position: float4(x, y, z, w));
    }
    
    public static func interpolate(a: Quaternion, b: Quaternion, blend: Float)->Quaternion {
        let result =  Quaternion(position: float4(0, 0, 0, 1))

        let dot = a.w * b.w + a.x * b.x * a.y * b.y + a.z *  b.z
        let blendI = 1.0 - blend

        if (dot < 0) {
            result.w = blendI * a.w + blend * -b.w;
            result.x = blendI * a.x + blend * -b.x;
            result.y = blendI * a.y + blend * -b.y;
            result.z = blendI * a.z + blend * -b.z;
        } else {
            result.w = blendI * a.w + blend * b.w;
            result.x = blendI * a.x + blend * b.x;
            result.y = blendI * a.y + blend * b.y;
            result.z = blendI * a.z + blend * b.z;
        }
        result.normalize();
        return result
    }
    
}
