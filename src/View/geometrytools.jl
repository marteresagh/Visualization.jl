
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

function helper_axis(affine_matrix = Matrix{Float64}(Lar.I,4,4)::Matrix)
	T = [0 1. 0 0; 0 0 1 0; 0 0 0 1]
	V = Common.apply_matrix(affine_matrix,T)
	return [GL.GLGrid(V,[[1,2]],GL.COLORS[2],1.),GL.GLGrid(V,[[1,3]],GL.COLORS[3],1.),GL.GLGrid(V,[[1,4]],GL.COLORS[4],1.)]
end
