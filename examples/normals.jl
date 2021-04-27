using Visualization

npoints = 100
pc = rand(2,npoints)
pc = vcat(pc,zeros(1,npoints))

normals = vcat(zeros(1,npoints),zeros(1,npoints),ones(1,npoints))

Visualization.VIEW([
    Visualization.points(pc),
    Visualization.normals(pc,normals; len = 0.5)
])
