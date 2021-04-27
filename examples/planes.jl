# using Visualization
# using Common
#
# # INPUT generation
# npoints = 100
# pc = rand(2,npoints)
# pc = vcat(pc,0.01*rand(1,npoints))
# plane1 = Hyperplane(PointCloud(pc),[0,0,1.],Common.centroid(pc))
#
# npoints = 50
# pc = rand(2,npoints).+1
# pc = vcat(pc,0.01*rand(1,npoints))
# plane2 = Hyperplane(PointCloud(pc),[0,0,1.],Common.centroid(pc))
#
# npoints = 30
# pc = rand(2,npoints).+2
# pc = vcat(pc,0.01*rand(1,npoints))
# plane3 = Hyperplane(PointCloud(pc),[0,0,1.],Common.centroid(pc))
#
# # VIEW
# PLANES=[plane1,plane2,plane3]
# GL.VIEW([
#     Visualization.planes(PLANES, false)...,
#     Visualization.axis_helper()...,
#     Visualization.axis_helper(Lar.t(Common.centroid(pc)...); x_color = GL.COLORS[6], y_color = GL.COLORS[7], z_color = GL.COLORS[5] )...
# ])
