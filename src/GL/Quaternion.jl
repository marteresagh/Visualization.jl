"""
	struct Quaternion

``Unit quaternions`` provide a convenient mathematical notation for representing ``orientations`` and ``rotations`` of objects in three dimensions.
See ``https://github.com/JuliaGeometry/Quaternions.jl/blob/master/src/Quaternion.jl``

# Example
See ``https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation``
"""
struct Quaternion

	w::Float64
	x::Float64
	y::Float64
	z::Float64

	# constructor
	function Quaternion()
		new(1,0,0,0)
	end

	# constructor
	function Quaternion(w::Float64,x::Float64,y::Float64,z::Float64)
		norm=sqrt(w * w + x * x + y * y + z * z)
		w/=norm
		x/=norm
		y/=norm
		z/=norm
		new(w,x,y,z)
	end

	# constructor
	function Quaternion(axis::Point3d,angle::Float64)
		axis=normalized(axis)
		c = cos(0.5*angle)
		s = sin(0.5*angle)
		new(c,s*axis[1],s*axis[2],s*axis[3])
	end

end

(*)(q::Quaternion, w::Quaternion) = Quaternion(
	q.w * w.w - q.x * w.x - q.y * w.y - q.z * w.z,
	q.w * w.x + q.x * w.w + q.y * w.z - q.z * w.y,
	q.w * w.y - q.x * w.z + q.y * w.w + q.z * w.x,
	q.w * w.z + q.x * w.y - q.y * w.x + q.z * w.w)




"""
	convertToQuaternion(T::Matrix4)

Transform the affine matrix `T::Matrix4` to quaternion.

# Example
`Euler Angles` to `Quaternion` Conversion.
By combining the quaternion representations of the Euler rotations we get for the Body 3-2-1 sequence, where the airplane first does ``yaw`` (Body-Z) turn during taxiing onto the runway, then ``pitches`` (Body-Y) during take-off, and finally ``rolls`` (Body-X) in the air.
```
 julia> Rx(a) =
 [1.0     0.0     0.0  0.0;
  0.0  cos(a) -sin(a)  0.0;
  0.0  sin(a)  cos(a)  0.0;
  0.0     0.0     0.0  1.0];

 julia> Ry(b) =
 [cos(a)  0.0  sin(a)  0.0;
  0.0     1.0     0.0  0.0;
 -sin(a)  0.0  cos(a)  0.0;
  0.0     0.0     0.0  1.0];

 julia> Rz(c) =
 [cos(a) -sin(a)  0.0  0.0;
  sin(a)  cos(a)  0.0  0.0;
 	 0.0    0.0   1.0  0.0;
 	 0.0    0.0   0.0  1.0];

 julia> T = GL.Matrix4( Rz(c) * Ry(b) * Rx(a) );
 4×4 MArray{Tuple{4,4},Float64,2,16}:
   0.75      -0.216506   0.625     0.0
   0.433013   0.875     -0.216506  0.0
  -0.5        0.433013   0.75      0.0
   0.0        0.0        0.0       1.0

 julia> q = GL.convertToQuaternion(T::GL.Matrix4)
 ViewerGL.Quaternion(0.9185586535436918, 0.1767766952966369, 0.30618621784789724, 0.1767766952966369)
```
"""
function convertToQuaternion(T::Matrix4)
	# See https://arxiv.org/pdf/math/0701759.pdf
	a2 = 1.0 + T[1,1] + T[2,2] + T[3,3]
	b2 = 1.0 + T[1,1] - T[2,2] - T[3,3]
	c2 = 1.0 - T[1,1] + T[2,2] - T[3,3]
	d2 = 1.0 - T[1,1] - T[2,2] + T[3,3]

	if a2 >= max(b2, c2, d2)
		a = sqrt(a2)/2
		return Quaternion(a, (T[3,2]-T[2,3])/4a, (T[1,3]-T[3,1])/4a, (T[2,1]-T[1,2])/4a)
	elseif b2 >= max(c2, d2)
		b = sqrt(b2)/2
		return Quaternion((T[3,2]-T[2,3])/4b, b, (T[2,1]+T[1,2])/4b, (T[1,3]+T[3,1])/4b)
	elseif c2 >= d2
		c = sqrt(c2)/2
		return Quaternion((T[1,3]-T[3,1])/4c, (T[2,1]+T[1,2])/4c, c, (T[3,2]+T[2,3])/4c)
	else
		d = sqrt(d2)/2
		return Quaternion((T[2,1]-T[1,2])/4d, (T[1,3]+T[3,1])/4d, (T[3,2]+T[2,3])/4d, d)
	end
end



"""
	convertToMatrix(q::Quaternion)

Quaternion to affine matrix `T::Matrix4` transformation.
# Example
```
julia> a,b,c = pi/6,pi/3,pi/24
(0.5235987755982988, 1.0471975511965976, 0.1308996938995747)

julia> T = GL.Matrix4( Rz(c) * Ry(b) * Rx(a) )
4×4 MArray{Tuple{4,4},Float64,2,16}:
  0.75      -0.216506   0.625     0.0
  0.433013   0.875     -0.216506  0.0
 -0.5        0.433013   0.75      0.0
  0.0        0.0        0.0       1.0

julia> q = GL.convertToQuaternion(T::GL.Matrix4)
ViewerGL.Quaternion(0.9185586535436918, 0.1767766952966369, 0.30618621784789724, 0.1767766952966369)

julia> GL.convertToMatrix(q::GL.Quaternion)
4×4 MArray{Tuple{4,4},Float64,2,16}:
  0.75      -0.216506   0.625     0.0
  0.433013   0.875     -0.216506  0.0
 -0.5        0.433013   0.75      0.0
  0.0        0.0        0.0       1.0
```
"""
function convertToMatrix(q::Quaternion)
	sx, sy, sz = 2q.w * q.x, 2q.w * q.y, 2q.w * q.z
	xx, xy, xz = 2q.x^2, 2q.x * q.y, 2q.x * q.z
	yy, yz, zz = 2q.y^2, 2q.y * q.z, 2q.z^2
	return Matrix4(
		1 - (yy + zz),      xy - sz,       xz + sy, 0.0,
		     xy + sz ,1 - (xx + zz),       yz - sx, 0.0,
		     xz - sy ,      yz + sx, 1 - (xx + yy), 0.0,
		0.0,0.0,0.0,1.0)
end
