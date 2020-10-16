using Visualization

npoints = 100
pc = rand(3,npoints)
rgb = rand(3,npoints)

GL.VIEW(
    [
    Visualization.points_color_from_rgb(pc,rgb)
    ]
)
