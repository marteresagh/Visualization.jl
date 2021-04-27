# """
# 	planes(PLANES::Array{Hyperplane,1}, box_oriented = true; affine_matrix = Matrix(Lar.I,4,4))
#
# Generate model of planes.
# """
# function planes(PLANES::Array{Hyperplane,1}, box_oriented = true; affine_matrix = Matrix(Lar.I,4,4))
#
# 	mesh = []
# 	for plane in PLANES
# 		pc = plane.inliers
# 		V,EV,FV = Common.DrawPlanes(plane; box_oriented=box_oriented)
# 		col = COLORS[rand(1:12)]
# 		push!(mesh,GLGrid(Common.apply_matrix(affine_matrix,V),FV,col));
# 		push!(mesh,	GLPoints(convert(Lar.Points,Common.apply_matrix(affine_matrix,pc.coordinates)'),col));
# 	end
#
# 	return mesh
# end
#
# """
# 	lines(LINES::Array{Hyperplane,1})
#
# Generate model of lines.
# """
# function lines(LINES::Array{Hyperplane,1})
#
# 	mesh = []
# 	for line in LINES
# 		V,EV = Common.DrawLines(line)
# 		col = COLORS[rand(1:12)]
#
# 		push!(mesh,	GLPoints(convert(Lar.Points,line.inliers.coordinates'),col));
# 		push!(mesh,GLGrid(V,EV,COLORS[12],1.0));
# 	end
#
# 	return mesh
# end
#
# """
# Generate model of lines.
# """
# function mesh_circles(CIRCLES::Array{Hypersphere,1})
#
# 	mesh = []
# 	for circle in CIRCLES
# 		V,EV = Lar.circle(circle.radius)()
# 		T = Common.apply_matrix(Lar.t(circle.center...),V)
# 		col = COLORS[rand(1:12)]
#
# 		push!(mesh,	GLPoints(convert(Lar.Points,circle.inliers.coordinates'),col));
# 		push!(mesh,GLGrid(T,EV,COLORS[12],1.0));
# 	end
#
# 	return mesh
# end

"""
	axis_helper(affine_matrix = Matrix{Float64}(Geometry.I,4,4)::Matrix)

An axis object to visualize the 3 orthogonal axes. It's possible apply an affine transformation.
The X axis is red. The Y axis is green. The Z axis is blue.
"""
function axis_helper(affine_matrix = Matrix{Float64}(LinearAlgebra.I,4,4)::Matrix;
			 		x_color=COLORS[2]::Point4d,
					y_color=COLORS[3]::Point4d,
					z_color=COLORS[4]::Point4d)

	T = [0 1. 0 0; 0 0 1 0; 0 0 0 1]
	V = apply_matrix(affine_matrix,T)
	return [GLGrid(V,[[1,2]],x_color,1.),GLGrid(V,[[1,3]],y_color,1.),GLGrid(V,[[1,4]],z_color,1.)]
end
