using Visualization

npoints = 100
pc = rand(3,npoints)
rgb = rand(3,npoints)

GL.VIEW(
    [
    Visualization.points(pc,rgb)
    ]
)

pc = rand(2,npoints)

GL.VIEW(
    [
    Visualization.points(pc; color = GL.COLORS[2], alpha = 0.3),
    Visualization.points(pc[:,[1,2,3,4]]; color = GL.COLORS[3],alpha = 1.),
    Visualization.points(pc[:,5]),
    ]
)
