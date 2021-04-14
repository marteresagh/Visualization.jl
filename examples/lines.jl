using Visualization
using Common

# INPUT generation
npoints = 100
pc = vcat(rand(1,npoints),0.01*rand(1,npoints))
line1 = Hyperplane(PointCloud(pc),[1,0.],Common.centroid(pc))

npoints = 50
pc = vcat(0.01*rand(1,npoints),rand(1,npoints))
line2 = Hyperplane(PointCloud(pc),[0.,1.],Common.centroid(pc))

# VIEW
LINES=[line1,line2]
GL.VIEW([
    Visualization.mesh_lines(LINES)...
])
