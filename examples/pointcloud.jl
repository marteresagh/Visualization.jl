using Visualization
using Common
npoints = 100
pc = rand(3,npoints)
rgb = rand(3,npoints)

GL.VIEW(
    [
    Visualization.points_color_from_rgb(pc,rgb)
    ]
)


pc = rand(2,npoints)

GL.VIEW(
    [
    #Visualization.points(pc,GL.COLORS[2],0.3),
    Visualization.points(pc[:,[1,2,3,4]],GL.COLORS[3],.3),
    Visualization.points(pc[:,1],GL.COLORS[12],.3)
    ]
)
