module Visualization

    using Common
    using ViewerGL
    GL = ViewerGL
	using Combinatorics

    # include code
    # dirs = readdir("src")
	# for dir in dirs
	# 	name = joinpath("src",dir)
    # 	if isdir(name)
	# 		for (root,folders,files) in walkdir(name)
	# 			for file in files
	# 				head = splitdir(root)[2]
	# 				#@show joinpath(head,file)
	# 			 	include(joinpath(head,file))
	# 			end
	# 		end
	# 	end
	# end

	include("View/color.jl")
	include("View/geometrytools.jl")
 	export GL
end # module
