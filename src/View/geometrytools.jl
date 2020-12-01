"""
Generate model of normals.
"""
function mesh_normals(points::Lar.Points, normals::Lar.Points)
	@assert size(points,2) == size(normals,2) "mesh_normals: not valid input"
	n = size(points,2)
	norm = [[i,i+n] for i in 1:n]
	totalpoints = hcat(V,normals)
	tnormals = similar(normals)
	for i in 1:n
		tnormals[:,i] = points[:,i] + normals[:,i]
	end
	totalpoints = hcat(points,tnormals)
	return GL.GLGrid(totalpoints,norm,GL.Point4d(1,1,1,1))
end

"""
Generate model of planes.
"""
function mesh_planes(PLANES::Array{Hyperplane,1})

	mesh = []
	for plane in PLANES
		pc = plane.inliers
		bb = Common.boundingbox(pc.coordinates)#.+([-u,-u,-u],[u,u,u])
		V = Common.intersectAABBplane(bb,plane.direction,plane.centroid)
		FV = Common.delaunay_triangulation(V[1:2,:])
		col = GL.COLORS[rand(1:12)]
		push!(mesh,GL.GLGrid(V,FV,col));
		push!(mesh,	GL.GLPoints(convert(Lar.Points,pc.coordinates'),col));
	end

	return mesh
end

"""
Generate model of lines.
"""
function mesh_lines(LINES::Array{Hyperplane,1})

	mesh = []
	for line in LINES
		V,EV = Common.DrawLine(line,0.0)
		col = GL.COLORS[rand(1:12)]

		push!(mesh,	GL.GLPoints(convert(Lar.Points,line.inliers.coordinates'),col));
		push!(mesh,GL.GLGrid(V,EV,GL.COLORS[12],1.0));
	end

	return mesh
end


"""
An axis object to visualize the 3 axes. It's possible apply an affine transformation.
The X axis is red. The Y axis is green. The Z axis is blue.
"""
function helper_axis(affine_matrix = Matrix{Float64}(Lar.I,4,4)::Matrix)
	T = [0 1. 0 0; 0 0 1 0; 0 0 0 1]
	V = Common.apply_matrix(affine_matrix,T)
	return [GL.GLGrid(V,[[1,2]],GL.COLORS[2],1.),GL.GLGrid(V,[[1,3]],GL.COLORS[3],1.),GL.GLGrid(V,[[1,4]],GL.COLORS[4],1.)]
end
