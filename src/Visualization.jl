__precompile__()

module Visualization

    using Common
    using ViewerGL
    GL = ViewerGL
	using Combinatorics

    # include code
	include("View/color.jl")
	include("View/geometrytools.jl")


 	export GL
end # module
