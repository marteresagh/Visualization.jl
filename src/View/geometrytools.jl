#TODO da fixare
# function mesh_planes(PLANES::Array{Hyperplane,1})
#
# 	mesh = []
# 	for plane in PLANES
# 		pc = plane.points
# 		pp = plane.plane
# 		bb = Lar.boundingbox(pc.points)#.+([-u,-u,-u],[u,u,u])
# 		V = PointClouds.intersectAABBplane(bb,pp.normal,pp.centroid)
# 		FV = PointClouds.DTprojxy(V)
# 		col = GL.COLORS[rand(1:12)]
# 		push!(mesh,GL.GLGrid(V,FV,col));
# 		push!(mesh,	GL.GLPoints(convert(Lar.Points,pc.points'),col));
# 	end
#
# 	return mesh
# end


function mesh_lines(LINES::Array{Hyperplane,1})

	mesh = []
	for line in LINES
		V,EV = Common.DrawLine(line,0.0)
		col = GL.COLORS[rand(1:12)]
		push!(mesh,GL.GLGrid(V,EV,col));
		push!(mesh,	GL.GLPoints(convert(Lar.Points,line.points.coordinates'),col));
	end

	return mesh
end
