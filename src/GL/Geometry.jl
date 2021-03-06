const M44 = convert(Matrix4, Matrix{Float64}(I,4,4))

"""
	GLHull(points::Array{Float64,2})::GLMesh

To generate the `mesh` of the ``convex hull`` of an array of `points`.
# Example
```
points = rand(50,3)
VIEW([
      GLHull(points)
      GLAxis(Point3d(0,0,0),Point3d(1,1,1))
])
```
"""
function GLHull(points::Points,color=COLORS[1])::GLMesh
	#data preparation
	ch = QHull.chull(points)
	verts = ch.vertices
	vdict = Dict(zip(verts, 1:length(verts)))
	trias = [[vdict[u],vdict[v],vdict[w]] for (u,v,w) in ch.simplices]
	points = points[verts,:]
	# mesh building
	vertices,normals = lar4mesh(points,trias)
	colors=Vector{Float32}()
	for k=1:length(vertices) append!(colors,color) end

	ret=GLMesh(GL_TRIANGLES)
	ret.vertices = GLVertexBuffer(vertices)
	ret.normals  = GLVertexBuffer(normals)
	ret.colors  = GLVertexBuffer(colors)
	return ret
end


"""
	GLHull2d(points::Array{Float64,2})::GLMesh

To generate the `mesh` of the 1D polygonal ``convex hull`` of an array of 2D `points`.
# Example

```
points = rand(50,2)
VIEW([
	  GLHull2d(points)
	  GLAxis(Point3d(0,0,0),Point3d(1,1,1))
])
```
"""
function GLHull2d(points::Points,color=COLORS[1])::GLMesh # points by row

	ch = QHull.chull(points)
	verts = ch.vertices
	vdict = Dict(zip(verts, 1:length(verts)))
	edges = [[vdict[u],vdict[v]] for (u,v) in ch.simplices]
	points = points[verts,:]
	faces = edges

	vertices=Vector{Float32}()
	#normals =Vector{Float32}()
	colors  =Vector{Float32}()
	for face in faces
		p2,p1=points[face[1],:],points[face[2],:]
		t=p2-p1;  n=LinearAlgebra.normalize([-t[2];+t[1]])

		p1 = convert(Point3d, [p1; 0.0])
		p2 = convert(Point3d, [p2; 0.0])
		#n  = convert(Point3d, [ n; 0.0])
		c = color

		append!(vertices,p1); append!(colors,c); # append!(normals,n)
		append!(vertices,p2); append!(colors,c); # append!(normals,n);
	end

	ret=GLMesh(GL_LINES)
	ret.vertices = GLVertexBuffer(vertices)
	ret.colors = GLVertexBuffer(colors)
	#ret.normals  = GLVertexBuffer(normals)
	return ret
end

function circularsort(center, points)
if size(center,2)==2 center=[center zeros(size(center,1),1)] end
if size(points,2)==2 points=[points zeros(size(points,1),1)] end
	V = points .- center
	v1 = @view V[1,:]; v2 = @view V[2,:];
	v3 = LinearAlgebra.normalize(LinearAlgebra.cross(v1,v2))
	basis = [normalize(v1) normalize(v2) v3]
	vecs2 = (V * basis)[:,1:2]

	theangle(k) = atan(vecs2[k,2], vecs2[k,1])
	pairs = [[theangle(k), k] for k=1:size(vecs2,1)]
	ordidx = [Int(index) for (alpha,index) in sort(pairs)]
	push!(ordidx, ordidx[1])
	edges = [[ordidx[k],ordidx[k+1]] for k=1:length(ordidx)-1]
	return edges
end


"""
	GLHulls(V::Array{Float64,2},FV::Array{Array{Int64,1},1})::GLMesh

To generate the `mesh` of triangles generated by 2D/3D `points`.
# Example

```
points = rand(50,2)
VIEW([
	  GLHull2d(points)
	  GLAxis(Point3d(0,0,0),Point3d(1,1,1))
])
```
"""
function GLHulls(V::Points,
	FV::Cells, back::Point4d=COLORS[1], alpha=0.2)::GLMesh

	vertices=Vector{Float32}()
	normals =Vector{Float32}()
	colors =Vector{Float32}()
	Rn = size(V,1)
	back = back.*alpha

	for face in FV
		points = convert(Points, V[:,face]')
		center = sum(points,dims=1)/size(points,1)
		#edges = circularsort(center, points)
		ch = QHull.chull(points)
		verts = ch.vertices
		vdict = Dict(zip(1:length(face), face))
		edges = [[vdict[u],vdict[v]] for (u,v) in ch.simplices]
		#faces = edges # TODO generalize to 3D convex cells


		for (v1,v2) in edges
			p2,p1 = V[:,v2], V[:,v1]

			p1 = convert(Point3d, Rn==2 ? [p1; 0.0] : p1)
			p2 = convert(Point3d, Rn==2 ? [p2; 0.0] : p2)
			p3 = convert(Point3d, Rn==2 ? [center 0.0] : center)
			n=computeNormal(p1,p2,p3)

			append!(vertices,p1); append!(normals,n); append!(colors,back)
			append!(vertices,p2); append!(normals,n); append!(colors,back)
			append!(vertices,p3); append!(normals,n); append!(colors,back)
		end
	end
	ret=GLMesh(GL_TRIANGLES)
	ret.vertices = GLVertexBuffer(vertices)
	ret.normals  = GLVertexBuffer(normals)
	ret.colors  = GLVertexBuffer(colors)
	return ret
end



"""
      GLPolygon(V::Points,EV::ChainOp,FE::ChainOp)::GLMesh

Generate the `GLMesh` ``mesh`` to visualize a ``2D polygon``.

The input polygon is very general, according to the ``Lar`` scheme: it may be non-connected, and may contain multiple holes, i.e. may be non-contractible.

# Example

```
V = hcat([[0,0],[1,0],[1,1],[0,1],[.25,.25],[.75,.25],[.75,.75],[.25,.75]]...)
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
```
"""
function GLPolygon(V::Points,copEV::ChainOp,copFE::ChainOp)::GLMesh
@show V;
@show SparseArrays.findnz(copEV);
@show SparseArrays.findnz(copFE);
      # triangulation
      W = convert(Points, V)
			#if size(W,2)==2 W=[W zeros(size(W,1))] end
      EV = cop2lar(copEV)
      trias = triangulate2d(V,EV)
      # mesh building
      vertices,normals = lar4mesh(W,trias)
      ret=GLMesh(GL_TRIANGLES)
      ret.vertices = GLVertexBuffer(vertices)
      ret.normals  = GLVertexBuffer(normals)
      return ret
end

"""
      GLPolygon(V::Points,EV::Cells)::GLMesh

Generate the `GLMesh` ``mesh`` to visualize a ``2D polygon``.

The input polygon is very general, according to the ``Lar`` scheme: it may be non-connected, and may contain multiple holes, i.e. may be non-contractible.

# Example

```
V = hcat([[0,0],[1,0],[1,1],[0,1],[.25,.25],[.75,.25],[.75,.75],[.25,.75]]...)
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]

VIEW([
      GLPolygon(V,EV)
      GLAxis(Point3d(0,0,0),Point3d(1,1,1))
])
```
"""
function GLPolygon(V::Points,EV::Cells)::GLMesh
      trias = triangulate2d(V,EV)
      V = two2three(V)

      # mesh building
      vertices,normals = lar4mesh(V,trias)
      ret=GLMesh(GL_TRIANGLES)
      ret.vertices = GLVertexBuffer(vertices)
      ret.normals  = GLVertexBuffer(normals)
      return ret
end



"""
	GLLar2gl(V::Array{Float64,2}, CV::Array{Array{Int64,1},1})

Generate the `GLMesh` ``mesh`` to visualize a ``LAR`` model.

# Example
```
V,CV = cuboidGrid([10,20,1])
VIEW([
      GLLar2gl(V,CV)
      GLAxis(Point3d(0,0,0),Point3d(1,1,1))
])
```
"""
function GLLar2gl(V::Points, CV::Cells)::GLMesh
	points = convert(Array{Float64,2},V') # points by rows
	vertices=Vector{Float32}()
	normals =Vector{Float32}()

	dim = size(points,2)

	for cell in CV
		ch = QHull.chull(points[cell,:])
		verts = ch.vertices
		trias = ch.simplices
		vdict = Dict(zip(verts, 1:length(verts)))
		fdict = Dict(zip(1:length(cell), cell))
		faces = [[vdict[u],vdict[v],vdict[w]] for (u,v,w) in trias]
		triangles = [[fdict[v1],fdict[v2],fdict[v3]] for (v1,v2,v3) in faces]

		cellverts,cellnorms = lar4mesh(points,triangles)
		append!(vertices,cellverts)
		append!(normals,cellnorms)
	end

	ret=GLMesh(GL_TRIANGLES)
	ret.vertices = GLVertexBuffer(vertices)
	ret.normals  = GLVertexBuffer(normals)
	return ret
end

"""
	GLLines(points::Points,lines::Cells,color=COLORS[12])::GLMesh
# Example
```
julia> (points, lines) = text("PLaSM");

julia> mesh = GLLines(points::Points,lines::Cells);

julia> mesh
```
"""
function GLLines(points::Points,lines::Cells,color=COLORS[12],alpha=1.)::GLMesh
      points = convert(Points, points')
      vertices=Vector{Float32}()
	  colors  = Vector{Float32}()
      #normals =Vector{Float32}()
	  if size(points,2) == 2
		  points = [points zeros(size(points,1),1)]
	  end
	  color *= alpha
      for line in lines
            p2,p1 = points[line[1],:], points[line[2],:]
            t=p2-p1;  n=LinearAlgebra.normalize([-t[2];+t[1];t[3]])

            p1 = convert(Point3d, p1)
            p2 = convert(Point3d, p2)
            n  = convert(Point3d,  n)

            append!(vertices,p1); append!(colors,color)
            append!(vertices,p2); append!(colors,color)
      end
      ret=GLMesh(GL_LINES)
      ret.vertices = GLVertexBuffer(vertices)
      ret.colors  = GLVertexBuffer(colors)
      return ret
end



"""
	GLPoints(points::Points,color=COLORS[12])::GLMesh

Transform an array of points into a mesh of points.
# Example
```
julia> points = rand(50,3)

julia> GLPoints(points::Points)::GLMesh
ViewerGLMesh(0, [1.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0; 0.0 0.0 1.0 0.0; 0.0 0.0 0.0 1.0], ViewerGLVertexArray(-1), ViewerGLVertexBuffer(-1, Float32[0.469546, 0.117036, 0.70094, 0.645718, 0.453858, 0.750581, 0.220592, 0.19583, 0.192406, 0.860808  …  0.956595, 0.395031, 0.805344, 0.111219, 0.0562529, 0.923611, 0.634622, 0.794003, 0.0861098, 0.600665]), ViewerGLVertexBuffer(-1, Float32[]), ViewerGLVertexBuffer(-1, Float32[]))
```
"""
function GLPoints(points::Points,color=COLORS[12])::GLMesh # points by row
      #points = convert(Points, points')
	  if size(points,2) == 2
		  points = [points zeros(size(points,1),1)]
	  end
      vertices=Vector{Float32}()
      colors =Vector{Float32}()
      for k=1:size(points,1)
		point = convert(Point3d,points[k,:])
        append!(vertices,convert(Point3d,point)); append!(colors,color)
      end
      ret=GLMesh(GL_POINTS)
      ret.vertices = GLVertexBuffer(vertices)
      ret.colors  = GLVertexBuffer(colors)
      return ret
end



"""
	GLPolyhedron(V::Points, FV::Cells, T::Matrix4=M44)::GLMesh

Transform a Lar model of a 3D polyhedron, given as a couple (V,FV), into a ModernGL mesh.
# Example
```
julia> V,(VV,EV,FV,CV) = cuboid([1,1,1],true);

julia> mesh = GLPolyhedron(V::Points, FV::Cells);

julia> mesh
```
"""
function GLPolyhedron(V::Points, FV::Cells, T::Matrix4=M44)::GLMesh
	# data preparation
	function mycat(a::Cells)
		out=[]
		for cell in a append!(out,cell) end
		return out
	end
	vindexes = sort(collect(Set(mycat(FV))))
	W = V[:,vindexes]
	vdict = Dict(zip(vindexes,1:length(vindexes)))
	triangles = [[vdict[u],vdict[v],vdict[w]] for (u,v,w) in FV]
	points = (M44 * [W; ones(1,size(W,2))])[1:3,:]
	points = convert(Points, points') # points by row

	# mesh building
        vertices,normals = lar4mesh(points,triangles)
        ret=GLMesh(GL_TRIANGLES)
        ret.vertices = GLVertexBuffer(vertices)
        ret.normals  = GLVertexBuffer(normals)
        return ret
end



"""
	GLPol(V::Points, CV::Cells,color=COLORS[1],alpha=1.0)::GLMesh

Create the GLMesh for a cellular complex with general convex 3-cells.

Mirror the behavior of MKPOL primitive of PLaSM language:
Convert the convex hull of each cell in a set of triangles.
"""
function GLPol(V::Points, CV::Cells,color=COLORS[1],alpha=1.0)::GLMesh
	trias,triangles = [],[]
	vcount = 0;
	outpoints = Array{Float64,2}(undef,0,3)
	#data preparation
	color *= alpha
	for cell in CV
		if length(cell)>=3
			points = convert(Array{Float64,2}, V[:,cell]')
			ch = QHull.chull(points)
			trias = ch.simplices
			m = size(ch.points,1)
			trias = [triangle .+ vcount for triangle in ch.simplices]
			append!(triangles,trias)
			outpoints = [outpoints; ch.points]
			vcount += m
		elseif length(cell)==2
			points = convert(Points, V[:,cell]')
			line = [1,2]
			m = 2
			lines = [line .+ vcount]
			append!(triangles,lines)
			outpoints = [outpoints; points]
			vcount += m
		end
	end
	# mesh building
	FW = convert(Cells,triangles)
	W = convert(Points,outpoints')
	mesh = GLGrid(W,FW,color);

	# colors = Vector{Point4d}()
	# c = color
	# for triangle in triangles
	# 	append!(colors,c); append!(colors,c); append!(colors,c)
	# end
	# mesh.colors  = GLVertexBuffer(colors)
end

# mesh = GLPol(V,CV, Point4d(1,1,1,0.2))
# VIEW([ mesh ]);


"""
	GLGrid(V::Points,CV::Cells,color=COLORS[1])::GLMesh

A grid is defined here as a cellular `p`-complex where all `p`-cells have the same arity, i.e. the same length as lists of vertices. E.g. are ``grids`` the sequences of points, lines, triangles, quads, `p`-cuboids.
```

```
"""
function GLGrid(V::Points,CV::Cells,c=COLORS[1],alpha=1.0::Float64)::GLMesh
	# test if all cells have same length
	ls = map(length,CV)
#	@assert( (&)(map((==)(ls[1]),ls)...) == true )

	n = size(V,1)  # space dimension
	points = embed(3-n)((V,CV))[1]
	cells = CV
	len = length(cells[1])  # cell dimension

	color = c
	color[4] = alpha
	c = Point4d(color)

	vertices= Vector{Float32}()
	normals = Vector{Float32}()
	colors  = Vector{Float32}()

      if len==1   # zero-dimensional grids
		ret=GLMesh(GL_POINTS)
		for k=1:size(points,2)
			p1 = convert(Point3d, points[:,k])
			append!(vertices,p1); #append!(normals,n)
			append!(colors,c); #append!(normals,n)
		end
      elseif len==2   # one-dimensional grids
		ret=GLMesh(GL_LINES)
		for k=1:length(cells)
			p1,p2=cells[k]
			p1 = convert(Point3d, points[:,p1]);
			p2 = convert(Point3d, points[:,p2])
			t = p2-p1;
			n = LinearAlgebra.normalize([-t[2];+t[1];t[3]])
			#n  = convert(Point3d, n)
			append!(vertices,p1); append!(vertices,p2);
			append!(normals,n);   append!(normals,n);
			append!(colors,c);    append!(colors,c);
		end
      elseif len==3 # triangle grids
		vertices=Vector{Float32}()
		normals =Vector{Float32}()
		colors =Vector{Float32}()
		ret=GLMesh(GL_TRIANGLES)
		for k=1:length(cells)
			p1,p2,p3=cells[k]
			p1 = convert(Point3d, points[:,p1]);
			p2 = convert(Point3d, points[:,p2])
			p3 = convert(Point3d, points[:,p3])
			n = computeNormal(p1,p2,p3)
			append!(vertices,p1); append!(vertices,p2); append!(vertices,p3);
			append!(normals,n);   append!(normals,n);   append!(normals,n);
			append!(colors,c);    append!(colors,c);    append!(colors,c);
		end
      elseif len==4  # quad grids
		vertices=Vector{Float32}()
		normals =Vector{Float32}()
		colors =Vector{Float32}()
		ret=GLMesh(GL_QUADS)
		for k=1:length(cells)
			p1,p2,p3,p4=cells[k]
			p1 = convert(Point3d, points[:,p1]);
			p2 = convert(Point3d, points[:,p2])
			p3 = convert(Point3d, points[:,p3])
			p4 = convert(Point3d, points[:,p4])
			n = 0.5*computeNormal(p1,p2,p3)
			append!(vertices,p1); append!(vertices,p2); append!(vertices,p4); append!(vertices,p3);
			append!(normals,n);   append!(normals,n);   append!(normals,n);   append!(normals,n);
			append!(colors,c);    append!(colors,c);    append!(colors,c);    append!(colors,c);
		end
      else # dim > 3
            error("cannot visualize dim > 3")
      end
      ret.vertices = GLVertexBuffer(vertices)
	  ret.normals  = GLVertexBuffer(normals)
	  ret.colors  = GLVertexBuffer(colors)
      return ret
end



# ////////////////////////////////////////////////////////////
"""
	GLExplode(V,FVs,sx=1.2,sy=1.2,sz=1.2,colors=1,alpha=0.2::Float64)

"""
function GLExplode(V,FVs,sx=1.2,sy=1.2,sz=1.2,colors=1,alpha=0.2::Float64)
	assembly = explodecells(V,FVs,sx,sy,sz)
	meshes = Any[]
	for k=1:length(assembly)
		if assembly[k] ≠  Any[]
			# Lar model with constant lemgth of cells, i.e a GRID object !!
			V,FV = assembly[k]
			col = Point4d(1,1,1,1)
			# cyclic color + random color components
			if colors == 1
				col = COLORS[1]
			elseif 2 <= colors <= 12
				col = COLORS[colors]
			else # colors > 12: cyclic colors w random component
				col = COLORS[(k-1)%12+1] - (rand(Float64,4)*0.1)
			end
			#col *= alpha
			push!(meshes, GLGrid(V,FV,col,alpha) )
		end
	end
	return meshes
end
