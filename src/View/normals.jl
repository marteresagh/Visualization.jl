"""
Generate model of normals.
"""
function normals(points::Points, normals::Points; len=1.::Float64)
	@assert size(points,2) == size(normals,2) "normals: not valid input"
	n = size(points,2)
	norm = [[i,i+n] for i in 1:n]
	totalpoints = hcat(points,normals)
	tnormals = similar(normals)
	for i in 1:n
		tnormals[:,i] = points[:,i] + len*normals[:,i]
	end
	totalpoints = hcat(points,tnormals)
	return GLGrid(totalpoints,norm,Point4d(1,1,1,1))
end
