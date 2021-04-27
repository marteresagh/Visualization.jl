using Visualization

npoints = 100
pc = rand(3,npoints)
rgb = rand(3,npoints)

Visualization.VIEW(
    [
    Visualization.points(pc,rgb)
    ]
)

pc = rand(2,npoints)

Visualization.VIEW(
    [
    Visualization.points(pc; color = Visualization.COLORS[2], alpha = 0.3),
    Visualization.points(pc[:,[1,2,3,4]]; color = Visualization.COLORS[3],alpha = 1.),
    Visualization.points(pc[:,5]),
    ]
)
