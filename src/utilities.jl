# funzioni ausiliari da tenere da parte
# esempi

using Common
using FileManager
using Visualization


function show_las(files; affine_matrix = Matrix{Float64}(Common.I,4,4))
    points = []
    for file in files
        PC = FileManager.las2pointcloud(file)
        push!(points,Visualization.points(Common.apply_matrix(affine_matrix,PC.coordinates),PC.rgbs))
    end
    return points
end


function show_octrees(files; affine_matrix = Matrix{Float64}(Common.I,4,4))
    octrees = []
    for file in files
        aabb = FileManager.las2aabb(file)
        V,EV = Common.getmodel(aabb)
        push!(octrees, Visualization.GLGrid(Common.apply_matrix(affine_matrix,V),EV,Visualization.YELLOW,1.0))
    end
    return octrees
end


pointclouds_mesh = show_las(files)
octrees_mesh = show_octrees(files)


Visualization.VIEW([
    pointclouds_mesh...,
    octrees_mesh...
])
