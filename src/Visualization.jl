__precompile__()

module Visualization

    using Common
    using ViewerGL
    GL = ViewerGL
	using Combinatorics

    # include code
	include("View/color.jl")
	include("View/objects.jl")
	include("View/normals.jl")


 	export GL
end # module
