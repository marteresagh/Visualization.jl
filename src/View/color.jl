"""
	mesh_color_from_rgb(V::Points,CV::Cells,rgb::Points,alpha=1.0)::GL.GLMesh

Draw colored points, edges, triangles or tetrahedrons.
"""
function mesh_color_from_rgb(V::Points,CV::Cells,rgb::Points;alpha=1.0)::GL.GLMesh

	function viewtetra(V::Points, CV::Cells,rgb::Points,alpha)::GL.GLMesh
		triangles = Array{Int64,1}[]
		#data preparation
		for cell in CV
			newsimplex = collect(Combinatorics.combinations(cell,3))
			append!(triangles,newsimplex)
		end
		# mesh building
		unique!(sort!.(triangles))
		mesh = mesh_color_from_rgb(V,triangles,rgb,alpha);
	end

	n = size(V,1)  # space dimension
	points = GL.embed(3-n)((V,CV))[1]
	cells = CV
	len = length(cells[1])  # cell dimension

	vertices = Vector{Float32}()
	normals = Vector{Float32}()
	colors  = Vector{Float32}()

	if len == 1   # zero-dimensional grids
		ret = GL.GLMesh(GL.GL_POINTS)
		for k = 1:size(points,2)
			c1 = GL.Point4d(rgb[:,k]...,alpha)
			p1 = convert(GL.Point3d, points[:,k])
			append!(vertices,p1); #append!(normals,n)
			append!(colors,c1); #append!(normals,n)
		end
	elseif len == 2   # one-dimensional grids
		ret = GL.GLMesh(GL.GL_LINES)
		for k = 1:length(cells)
			p1,p2=cells[k]
			c1 = GL.Point4d(rgb[:,p1]...,alpha)
			c2 = GL.Point4d(rgb[:,p2]...,alpha)
			p1 = convert(GL.Point3d, points[:,p1]);
			p2 = convert(GL.Point3d, points[:,p2]);
			t = p2-p1;
			n = Geometry.normalize([-t[2];+t[1];t[3]])
			#n  = convert(GL.Point3d, n)
			append!(vertices,p1); append!(vertices,p2);
			append!(normals,n);   append!(normals,n);
			append!(colors,c1);    append!(colors,c2);
		end
	elseif len == 3
		ret = GL.GLMesh(GL.GL_TRIANGLES)
		for k = 1:length(cells)
			p1,p2,p3=cells[k]
			c1 = GL.Point4d(rgb[:,p1]...,alpha)
			c2 = GL.Point4d(rgb[:,p2]...,alpha)
			c3 = GL.Point4d(rgb[:,p3]...,alpha)
			p1 = convert(GL.Point3d, points[:,p1]);
			p2 = convert(GL.Point3d, points[:,p2]);
			p3 = convert(GL.Point3d, points[:,p3]);
			n = GL.computeNormal(p1,p2,p3)
			append!(vertices,p1); append!(vertices,p2); append!(vertices,p3);
			append!(normals,n);   append!(normals,n);   append!(normals,n);
			append!(colors,c1);   append!(colors,c2);   append!(colors,c3);
		end
	elseif len == 4
		return viewtetra(V,CV,rgb,alpha)
	end
	ret.vertices = GL.GLVertexBuffer(vertices)
	ret.normals  = GL.GLVertexBuffer(normals)
	ret.colors  = GL.GLVertexBuffer(colors)
	return ret
end

"""
	points(V::Points,rgb::Points,alpha=1.0)::GL.GLMesh

Draw colored point clouds.
"""
function points(V::Points,rgb::Points;alpha=1.0)::GL.GLMesh
	VV = [[i] for i in 1:size(V,2)]
	return mesh_color_from_rgb(V,VV,rgb;alpha=alpha)
end


"""
	points(points::Points,color=GL.COLORS[12]::GL.Points4d,alpha=1.0::Float64)::GL.GLMesh

Draw points.
"""
function points(points::Points;color=GL.COLORS[12]::GL.Point4d,alpha=1.0::Float64)::GL.GLMesh

	if size(points,1) == 2
		points = vcat(points,zeros(size(points,2))')
	end

	vertices = Vector{Float32}()
	colors = Vector{Float32}()

	for k=1:size(points,2)
		point = convert(GL.Point3d,points[:,k])
		append!(vertices,point)
		append!(colors,GL.Point4d(color[1:3]...,alpha))
	end

	ret = GL.GLMesh(GL.GL_POINTS)
	ret.vertices = GL.GLVertexBuffer(vertices)
	ret.colors  = GL.GLVertexBuffer(colors)

	return ret
end

function points(point::Point;color=GL.COLORS[12]::GL.Point4d,alpha=1.0::Float64)::GL.GLMesh
	pt = hcat(point)
	return points(pt;color=color,alpha=alpha)
end
