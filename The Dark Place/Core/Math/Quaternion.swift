
import simd
import Foundation

public class Quaternion {
    private var _x: Float = 0
    private var _y: Float = 0
    private var _z: Float = 0
    private var _w: Float = 0

    init(_ x: Float,_ y: Float,_ z: Float,_ w: Float) {
        self._x = x
        self._y = y
        self._z = z
        self._w = w
    }
    
    init(_ axis: float3, _ angle: Float) {
        let sinHalfAngle: Float = sin(angle / 2.0)
        let cosHalfAngle: Float = cos(angle / 2.0)
        
        self._x = axis.x * sinHalfAngle
        self._y = axis.y * sinHalfAngle
        self._z = axis.z * sinHalfAngle
        self._w = cosHalfAngle
    }
}

//Properties
extension Quaternion {
    public var forward: float3 { return float3(0,0,1).rotate(self) }
    public var back: float3 { return float3(0, 0,-1).rotate(self) }
    public var up: float3 { return float3(0,1,0).rotate(self) }
    public var down: float3 { return float3(0,-1,0).rotate(self) }
    public var right: float3 { return float3(1,0,0).rotate(self) }
    public var left: float3 { return float3(-1,0,0).rotate(self) }
    
    func getX()->Float { return self._x }
    func getY()->Float { return self._y }
    func getZ()->Float { return self._z }
    func getW()->Float { return self._w }
    
    func setX(_ x: Float) { self._x = x }
    func setY(_ y: Float) { self._y = y }
    func setZ(_ z: Float) { self._z = z }
    func setW(_ w: Float) { self._w = w }
    
    
    public var length: Float { return sqrt(_x * _x + _y * _y + _z * _z + _w * _w) }
    
    public var normalized: Quaternion { return Quaternion(_x / self.length, _y / self.length, _z / self.length, _w / self.length) }
    
    public var conjugate: Quaternion { return Quaternion(-_x, -_y, -_z, -_w) }
    
    public var toRotationMatrix: matrix_float4x4{
        var matrix = matrix_identity_float4x4
        let x = _x
        let y = _y
        let z = _z
        let w = _w
        
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
}

//Functions
extension Quaternion {
    public func mul(_ r: Float)->Quaternion {
        return Quaternion(_x * r, _y * r, _z * r, _w * r)
    }
    
    public func mul(_ r: Quaternion)->Quaternion {
        let w: Float = _w * r.getW() - _x * r.getX() - _y * r.getY() - _z * r.getZ()
        let x: Float = _x * r.getW() + _w * r.getX() + _y * r.getZ() - _z * r.getY()
        let y: Float = _y * r.getW() + _w * r.getY() + _z * r.getX() - _x * r.getZ()
        let z: Float = _z * r.getW() + _w * r.getZ() + _x * r.getY() - _y * r.getX()
        
        return Quaternion(x, y, z, w)
    }
    
    public func mul(_ r: float3)->Quaternion {
        let w: Float = -_x * r.x - _y * r.y - _z * r.z
        let x: Float =  _w * r.x + _y * r.z - _z * r.y
        let y: Float =  _w * r.y + _z * r.x - _x * r.z
        let z: Float =  _w * r.z + _x * r.y - _y * r.x
        
        return Quaternion(x, y, z, w)
    }
    
    public func sub(_ r: Quaternion)->Quaternion {
        return Quaternion(_x - r.getX(), _y - r.getY(), _z - r.getZ(), _w - r.getW())
    }
    
    public func add(_ r: Quaternion)->Quaternion {
        return Quaternion(_x + r.getX(), _y + r.getY(), _z + r.getZ(), _w + r.getW())
    }
    
    public func dot(_ r: Quaternion)->Float {
        return _x * r.getX() + _y * r.getY() + _z * r.getZ() + _w * r.getW()
    }
    
    public func nLerp(dest: Quaternion, lerpFactor: Float, shortest: Bool)->Quaternion {
        var correctedDest: Quaternion = dest
        
        if(shortest && self.dot(dest) < 0) {
            correctedDest = Quaternion(-dest.getX(), -dest.getY(), -dest.getZ(), -dest.getW())
        }
        
        return correctedDest.sub(self).mul(lerpFactor).add(self).normalized
    }
    
    public func sLerp(dest: Quaternion, lerpFactor: Float, shortest: Bool)->Quaternion {
        let EPSILON: Float = Float(CGFloat.ulpOfOne)
        
        var cos: Float = self.dot(dest);
        var correctedDest: Quaternion = dest
        
        if(shortest && cos < 0) {
            cos = -cos
            correctedDest = Quaternion(-dest.getX(), -dest.getY(), -dest.getZ(), -dest.getW())
        }
        
        if(abs(cos) >= 1 - EPSILON) {
            return nLerp(dest: correctedDest, lerpFactor: lerpFactor, shortest: false)
        }
        
        let sinVal: Float = sqrt(1.0 - cos * cos)
        let angle: Float = atan2(sinVal, cos)
        let invSin: Float =  1.0 / sinVal
        
        let srcFactor: Float = sin((1.0 - lerpFactor) * angle) * invSin
        let destFactor: Float = sin((lerpFactor) * angle) * invSin
        
        return self.mul(srcFactor).add(correctedDest.mul(destFactor))
    }
    
    public func set(_ x: Float, _ y: Float, _ z: Float, _ w: Float){
        self._x = x
        self._y = y
        self._z = z
        self._w = w
    }
    
    public func set(_ r: Quaternion) {
        set(r.getX(), r.getY(), r.getZ(), r.getW())
    }
    
    public func equals(_ r: Quaternion)->Bool {
        return _x == r.getX() && _y == r.getY() && _z == r.getZ() && _w == r.getW()
    }
    
    public func fromMatrix(matrix: matrix_float4x4)->Quaternion{
        var val = float4(0)
        let diagonal = matrix.m00 + matrix.m11 + matrix.m22
        if (diagonal > 0) {
            let w4 = sqrt(diagonal + 1.0) * 2.0
            val.w = w4 / 4.0;
            val.x = (matrix.m21 - matrix.m12) / w4;
            val.y = (matrix.m02 - matrix.m20) / w4;
            val.z = (matrix.m10 - matrix.m01) / w4;
        }else if ((matrix.m00 > matrix.m11) && (matrix.m00 > matrix.m22)) {
            let x4 = sqrt(1.0 + matrix.m00 - matrix.m11 - matrix.m22) * 2.0
            val.w = (matrix.m21 - matrix.m12) / x4;
            val.x = x4 / 4.0;
            val.y = (matrix.m01 + matrix.m10) / x4;
            val.z = (matrix.m02 + matrix.m20) / x4;
        } else if (matrix.m11 > matrix.m22) {
            let y4 = sqrt(1.0 + matrix.m11 - matrix.m00 - matrix.m22) * 2.0
            val.w = (matrix.m02 - matrix.m20) / y4;
            val.x = (matrix.m01 + matrix.m10) / y4;
            val.y = y4 / 4.0;
            val.z = (matrix.m12 + matrix.m21) / y4;
        } else {
            let z4 = sqrt(1.0 + matrix.m22 - matrix.m00 - matrix.m11) * 2.0
            val.w = (matrix.m10 - matrix.m01) / z4;
            val.x = (matrix.m02 + matrix.m20) / z4;
            val.y = (matrix.m12 + matrix.m21) / z4;
            val.z = z4 / 4.0;
        }
        
        return Quaternion(val.x, val.y, val.z, val.w)
    }
}

