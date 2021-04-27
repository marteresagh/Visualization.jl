"""
	mutable struct GLMesh

Container of (a) the `Int32` code of primitives in `GLMesh`; (b) a matrix transform in local space, the `GLVertexArray`, and three objects `GLVertexBuffer` for `vertices`, `normals`, and `colors`. Inner constructors for initialization.

# Example
Generation of the object `GLMesh` modeling the unit 3D cube with one vertex on the origin:
```
julia> GLCuboid(Box3d(Point3d(0,0,0),Point3d(1,1,1)))
ViewerGLMesh(4, [1.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0; 0.0 0.0 1.0 0.0; 0.0 0.0 0.0 1.0], ViewerGLVertexArray(-1), ViewerGLVertexBuffer(-1, Float32[0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0  …  1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0]), ViewerGLVertexBuffer(-1, Float32[0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0  …  0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0]), ViewerGLVertexBuffer(-1, Float32[]))
```
"""
mutable struct GLMesh

	primitive::Int32
	T::Matrix4
	vertex_array::GLVertexArray

	vertices::GLVertexBuffer
	normals::GLVertexBuffer
	colors::GLVertexBuffer

	# constructor
	function GLMesh()
		ret=new(POINTS,Matrix4(),GLVertexArray(), GLVertexBuffer(),GLVertexBuffer(),GLVertexBuffer())
		finalizer(releaseGpuResources, ret)
		return ret
	end

	# constructor
	function GLMesh(primitive)
		ret=new(primitive,Matrix4(),GLVertexArray(),GLVertexBuffer(),GLVertexBuffer(),GLVertexBuffer())
		finalizer(releaseGpuResources, ret)
		return ret
	end

end



"""
	releaseGpuResources(mesh::GLMesh)

Release the memory allocated by the `vertex_array`, `vertices`, `normals`, and `colors` on the GPU.
"""
function releaseGpuResources(mesh::GLMesh)
	releaseGpuResources(mesh.vertex_array)
	releaseGpuResources(mesh.vertices)
	releaseGpuResources(mesh.normals)
	releaseGpuResources(mesh.colors)
end




"""
	computeNormal(p1::Point2d, p2::Point2d)

Compute in 2D the ccw normal vector to a line segment oriented from `p1` to `p2`.

# Example
```
julia> computeNormal(Point2d(1,0), Point2d(0.8,0.5))
2-element StaticArrays.MArray{Tuple{2},Float64,1,2}:
 0.9284766908852594
 0.37139067635410367

julia> computeNormal(Point2d(-0.8,0.5), Point2d(-1,0))
2-element StaticArrays.MArray{Tuple{2},Float64,1,2}:
 -0.9284766908852594
  0.37139067635410367
```
"""
function computeNormal(p1::Point2d, p2::Point2d)
	t = p2-p1
	n = Point2d(+t[2], -t[1])
	return normalized(n)
end



"""
	computeNormal(p0::Point3d,p1::Point3d,p2::Point3d)

Compute the ccw normal vector to a 3D triangle with orientation `(p0,p1,p2)`.
# Example
```
julia> computeNormal(Point3d(0,0,0), Point3d(1,0,0),Point3d(0,1,0))
3-element StaticArrays.MArray{Tuple{3},Float64,1,3}:
 0.0
 0.0
 1.0
```
"""
function computeNormal(p0::Point3d,p1::Point3d,p2::Point3d)
	return normalized(cross(p1-p0,p2-p0))
end




"""
	getBoundingBox(mesh::GLMesh)

Return an object of ViewerBox3d
# Example
```
julia> mesh = GLCuboid(Box3d(Point3d(0,0,0),Point3d(1,1,1)));

julia> getBoundingBox(mesh)
ViewerBox3d([0.0, 0.0, 0.0], [1.0, 1.0, 1.0])
```
"""
function getBoundingBox(mesh::GLMesh)
	box=invalidBox()
	vertices=mesh.vertices.vector
	for I in 1:3:length(vertices)
		point=Point3d(vertices[I+0],vertices[I+1],vertices[I+2])
		addPoint(box,point)
	end
	return box
end
function getBoundingBox(meshes::Array)
	box=invalidBox()
	for mesh in meshes
		vertices=mesh.vertices.vector
		for I in 1:3:length(vertices)
			point=Point3d(vertices[I+0],vertices[I+1],vertices[I+2])
			addPoint(box,point)
		end
	end
	return box
end




"""
	GLCuboid(box::Box3d)

Return the `GLMesh` modeling a 3-cuboid, i.e. the 3D parallelepiped parallel to the axes of reference frame).
# Example
```
julia> mesh = GLAxis(Point3d(-2,-2,-2),Point3d(+2,+2,+2));

julia> box = getBoundingBox(mesh)
ViewerBox3d([-2.0, -2.0, -2.0], [2.0, 2.0, 2.0])

julia> GLCuboid(box)
ViewerGLMesh(4, [1.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0; 0.0 0.0 1.0 0.0; 0.0 0.0 0.0 1.0], ViewerGLVertexArray(-1), ViewerGLVertexBuffer(-1, Float32[-2.0, 2.0, -2.0, 2.0, 2.0, -2.0, 2.0, -2.0, -2.0, -2.0  …  2.0, -2.0, 2.0, -2.0, -2.0, -2.0, 2.0, -2.0, 2.0, 2.0]), ViewerGLVertexBuffer(-1, Float32[0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0  …  0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0]), ViewerGLVertexBuffer(-1, Float32[]))
```
"""
function GLCuboid(box::Box3d)

	points=getPoints(box)
	faces=[[1, 2, 3, 4],[4, 3, 7, 8],[8, 7, 6, 5],[5, 6, 2, 1],[6, 7, 3, 2],[8, 5, 1, 4]]

	vertices=Vector{Float32}()
	normals =Vector{Float32}()
	for face in faces

		p3,p2,p1,p0 = points[face[1]],points[face[2]],points[face[3]],points[face[4]] # reverse order
		n=0.5*(computeNormal(p0,p1,p2) + computeNormal(p0,p2,p3))

		append!(vertices,p0); append!(normals,n)
		append!(vertices,p1); append!(normals,n)
		append!(vertices,p2); append!(normals,n)
		append!(vertices,p0); append!(normals,n)
		append!(vertices,p2); append!(normals,n)
		append!(vertices,p3); append!(normals,n)
	end

	ret=GLMesh(GL_TRIANGLES)
	ret.vertices = GLVertexBuffer(vertices)
	ret.normals  = GLVertexBuffer(normals)
	return ret
end



"""
	GLAxis(p0::Point3d,p1::Point3d)

Generate the GLMesh of a reference frame in local space.
Axes *position* and *length* is determined by the bounding box of `p1` and `p2`.
The reference frame is colored according to the *`RGB` colors*, respectively.

# Example
Note the size and position of reference frame in locol coordinates ...
```
VIEW([
	GLCuboid(Box3d(Point3d(0,0,0),Point3d(1,1,1)))
	GLAxis(Point3d(-2,-2,-2),Point3d(+2,+2,+2))
	])
```
"""
function GLAxis(p0::Point3d,p1::Point3d)

	vertices=Vector{Float32}()
	colors  =Vector{Float32}()

	R=Point4d(1,0,0,1); append!(vertices,p0); append!(vertices,Point3d(p1[1],p0[2],p0[3])); append!(colors,R); append!(colors,R)
	G=Point4d(0,1,0,1); append!(vertices,p0); append!(vertices,Point3d(p0[1],p1[2],p0[3])); append!(colors,G); append!(colors,G)
	B=Point4d(0,0,1,1); append!(vertices,p0); append!(vertices,Point3d(p0[1],p0[2],p1[3])); append!(colors,B); append!(colors,B)

	ret=GLMesh(GL_LINES)
	ret.vertices=GLVertexBuffer(vertices)
	ret.colors  =GLVertexBuffer(colors)
	return ret
end
