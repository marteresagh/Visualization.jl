__precompile__()
"""
	module ViewerGL

3D `interactive Viewer` for geometric and topological data.

Helper module for Julia's native ``OpenGL visualization``, forked from [Plasm.jl](https://github.com/plasm-language/pyplasm/tree/master/src/plasm.jl). To be used with geometric models and geometric expressions from [LinearAlgebraicRepresentation.jl](https://github.com/cvdlab/LinearAlgebraicRepresentation.jl), the simplest data structures for geometric and solid modeling :-)
"""
module Visualization

	using LinearAlgebra
	using SparseArrays
	using StaticArrays
	using ModernGL
	using GLFW
	import Base:*
	using QHull
	using DataStructures
	import Base.∘
	using Triangulate

	# using Combinatorics
	include("import_util_LAR.jl")

	include("GL/Point.jl")
	include("GL/Box.jl")
	include("GL/Matrix.jl")
	include("GL/Quaternion.jl")
	include("GL/Frustum.jl")
	#
	include("GL/GLUtils.jl")
	include("GL/GLVertexBuffer.jl")
	include("GL/GLVertexArray.jl")
	include("GL/GLMesh.jl")
	include("GL/GLShader.jl")
	include("GL/GLPhongShader.jl")
	#
	include("GL/Viewer.jl")
	include("GL/Geometry.jl")
	# include("GL/GLText.jl")  # TODO eliminare Lar
	include("GL/GLColorBuffer.jl")

	const GLFrame2 = GLAxis(Point3d(0,0,0),Point3d(1,1,0))
	const GLFrame = GLAxis(Point3d(0,0,0),Point3d(1,1,1))

    # include code
	include("View/color.jl")
	include("View/objects.jl")
	include("View/normals.jl")

end # module
