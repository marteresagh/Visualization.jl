const Points = Matrix # a single point is a Vector
const Point = Vector # a single point is a Vector
const Cells = Array{Array{Int,1},1}
const LAR = Union{ Tuple{Points, Cells},Tuple{Points, Cells, Cells} }
const ChainOp = SparseArrays.SparseMatrixCSC{Int8,Int}

"""
	apply_matrix(affineMatrix::Matrix, V::Points) -> Points

Apply affine transformation `affineMatrix` to points `V`.
"""
function apply_matrix(affineMatrix::Matrix, V::Points)
	m,n = size(V)
	W = [V; fill(1.0, (1,n))]
	T = (affineMatrix * W)[1:m,1:n]
	return T
end

function apply_matrix(affineMatrix::Matrix, V::Point)
	T = reshape(V,length(V),1)
	return apply_matrix(affineMatrix, T)
end

"""
	t(args::Array{Number,1}...)::Matrix

Return an *affine transformation Matrix* in homogeneous coordinates. Such `translation` Matrix has ``d+1`` rows and ``d+1`` columns, where ``d`` is the number of translation parameters in the `args` array.
"""
function Lar_t(args...)::Matrix
	d = length(args)
	mat = Matrix{Float64}(LinearAlgebra.I, d+1, d+1)
	for k in range(1, length=d)
        	mat[k,d+1]=args[k]
	end
	return mat
end

"""
	s(args::Array{Number,1}...)::Matrix


Return an *affine transformation Matrix* in homogeneous coordinates. Such `scaling` Matrix has ``d+1`` rows and ``d+1`` columns, where ``d`` is the number of scaling parameters in the `args` array.
"""
function Lar_s(args...)::Matrix
	d = length(args)
	mat = Matrix{Float64}(LinearAlgebra.I, d+1, d+1)
	for k in range(1, length=d)
		mat[k,k]=args[k]
	end
	return mat
end

"""
	r(args...)::Matrix

Return an *affine transformation Matrix* in homogeneous coordinates. Such `Rotation` Matrix has *dimension* either equal to 3 or to 4, for 2D and 3D rotation, respectively.
The `{Number,1}` of `args` either contain a single `angle` parameter in *radiants*, or a vector with three elements, whose `norm` is the *rotation angle* in 3D and whose `normalized value` gives the direction of the *rotation axis* in 3D.
"""
function Lar_r(args...)::Matrix
    args = collect(args)
    n = length(args)
    if n == 1 # rotation in 2D
        angle = args[1]; COS = cos(angle); SIN = sin(angle)
        mat = Matrix{Float64}(LinearAlgebra.I, 3, 3)
        mat[1,1] = COS;    mat[1,2] = -SIN;
        mat[2,1] = SIN;    mat[2,2] = COS;
    end

     if n == 3 # rotation in 3D
        mat = Matrix{Float64}(LinearAlgebra.I, 4, 4)
        angle = norm(args);
        if norm(args) != 0.0
			axis = args #normalize(args)
			COS = cos(angle); SIN= sin(angle)
			if axis[2]==axis[3]==0.0    # rotation about x
				mat[2,2] = COS;    mat[2,3] = -SIN;
				mat[3,2] = SIN;    mat[3,3] = COS;
			elseif axis[1]==axis[3]==0.0   # rotation about y
				mat[1,1] = COS;    mat[1,3] = SIN;
				mat[3,1] = -SIN;    mat[3,3] = COS;
			elseif axis[1]==axis[2]==0.0    # rotation about z
				mat[1,1] = COS;    mat[1,2] = -SIN;
				mat[2,1] = SIN;    mat[2,2] = COS;
			else
				I = Matrix{Float64}(LinearAlgebra.I, 3, 3); u = axis
				Ux=[0 -u[3] u[2] ; u[3] 0 -u[1] ;  -u[2] u[1] 1]
				UU =[u[1]*u[1]    u[1]*u[2]   u[1]*u[3];
					 u[2]*u[1]    u[2]*u[2]   u[2]*u[3];
					 u[3]*u[1]    u[3]*u[2]   u[3]*u[3]]
				mat[1:3,1:3]=COS*I+SIN*Ux+(1.0-COS)*UU
			end
		end
	end
	return mat
end



mutable struct Struct
	body::Array
	box
	name::AbstractString
	dim
	category::AbstractString

	function Struct()
		self = new([],Any,"new",Any,"feature")
		self.name = string(objectid(self))
		return self

	end

	function Struct(data::Array)
		self = Struct()
		self.body = data
		self.box = box(self)
		self.dim = length(self.box[1])
		return self
	end

	function Struct(data::Array,name)
		self = Struct()
		self.body=[item for item in data]
		self.box = box(self)
		self.dim = length(self.box[1])
		self.name = string(name)
		return self
	end

	function Struct(data::Array,name,category)
		self = Struct()
		self.body = [item for item in data]
		self.box = box(self)
		self.dim = length(self.box[1])
		self.name = string(name)
		self.category = string(category)
		return self
	end

	function name(self::Struct)
		return self.name
	end

	function category(self::Struct)
		return self.category
	end

	function len(self::Struct)
		return length(self.body)
	end

	function getitem(self::Struct,i::Int)
		return self.body[i]
	end

	function setitem(self::Struct,i,value)
		self.body[i]=value
	end

	function pprint(self::Struct)
		return "<Struct name: $(self.name)"
	end

	function set_name(self::Struct,name)
		self.name = string(name)
	end

	function clone(self::Struct,i=0)
		newObj = deepcopy(self)
		if i!=0
			newObj.name="$(self.name)_$(string(i))"
		end
		return newObj
	end

	function set_category(self::Struct,category)
		self.category = string(category)
	end

end

#######################################
"""
    point_in_face(point, V::Points, copEV::ChainOp)
Check if `point` is inside the area of the face bounded by the edges in `copEV`
"""
function point_in_face(point, V::Points, copEV::ChainOp)

    function pointInPolygonClassification(V,EV)

        function crossingTest(new, old, status, count)
        if status == 0
            status = new
            return status, (count + 0.5)
        else
            if status == old
                return 0, (count + 0.5)
            else
                return 0, (count - 0.5)
            end
        end
        end

        function setTile(box)
	        tiles = [[9,1,5],[8,0,4],[10,2,6]]
	        b1,b2,b3,b4 = box
	        function tileCode(point)
	            x,y = point
	            code = 0
	            if y>b1 code=code|1 end
	            if y<b2 code=code|2 end
	            if x>b3 code=code|4 end
	            if x<b4 code=code|8 end
	            return code
	        end
	        return tileCode
        end

        function pointInPolygonClassification0(pnt)
            x,y = pnt
            xmin,xmax,ymin,ymax = x,x,y,y
            tilecode = setTile([ymax,ymin,xmax,xmin])
            count,status = 0,0

            for k in 1:EV.m
                edge = EV[k,:]
                p1, p2 = V[edge.nzind[1], :], V[edge.nzind[2], :]
                (x1,y1),(x2,y2) = p1,p2
                c1,c2 = tilecode(p1),tilecode(p2)
                c_edge, c_un, c_int = xor(c1, c2), c1|c2, c1&c2

                if (c_edge == 0) & (c_un == 0) return "p_on"
                elseif (c_edge == 12) & (c_un == c_edge) return "p_on"
                elseif c_edge == 3
                    if c_int == 0 return "p_on"
                    elseif c_int == 4 count += 1 end
                elseif c_edge == 15
                    x_int = ((y-y2)*(x1-x2)/(y1-y2))+x2
                    if x_int > x count += 1
                    elseif x_int == x return "p_on" end
                elseif (c_edge == 13) & ((c1==4) | (c2==4))
                        status, count = crossingTest(1,2,status,count)
                elseif (c_edge == 14) & ((c1==4) | (c2==4))
                        status, count = crossingTest(2,1,status,count)
                elseif c_edge == 7 count += 1
                elseif c_edge == 11 count = count
                elseif c_edge == 1
                    if c_int == 0 return "p_on"
                    elseif c_int == 4
                        status, count = crossingTest(1,2,status,count)
                    end
                elseif c_edge == 2
                    if c_int == 0 return "p_on"
                    elseif c_int == 4
                        status, count = crossingTest(2,1,status,count)
                    end
                elseif (c_edge == 4) & (c_un == c_edge) return "p_on"
                elseif (c_edge == 8) & (c_un == c_edge) return "p_on"
                elseif c_edge == 5
                    if (c1==0) | (c2==0) return "p_on"
                    else
                        status, count = crossingTest(1,2,status,count)
                    end
                elseif c_edge == 6
                    if (c1==0) | (c2==0) return "p_on"
                    else
                        status, count = crossingTest(2,1,status,count)
                    end
                elseif (c_edge == 9) & ((c1==0) | (c2==0)) return "p_on"
                elseif (c_edge == 10) & ((c1==0) | (c2==0)) return "p_on"
                end
            end

            if (round(count)%2)==1
                return "p_in"
            else
                return "p_out"
            end
        end
        return pointInPolygonClassification0
    end

    return pointInPolygonClassification(V, copEV)(point) == "p_in"
end

function characteristicMatrix( CV )
	I = vcat( [ [k for h in CV[k]] for k=1:length(CV) ]...)
	J = vcat(CV...)
	Vals = [1 for k=1:length(I)]
	return sparse(I,J,Vals)
end

function cop2lar(cop::ChainOp)::Cells
	[findnz(cop[k,:])[1] for k=1:size(cop,1)]
end


"""
    constrained_triangulation2D(V::Points, EV::Cells) -> Cells
"""
function constrained_triangulation2D(V::Points, EV::Cells)
	triin = Triangulate.TriangulateIO()
	triin.pointlist = V
	triin.segmentlist = hcat(EV...)
	(triout, vorout) = Triangulate.triangulate("pQ", triin)
	trias = Array{Int64,1}[c[:] for c in eachcol(triout.trianglelist)]
	return trias
end


"""
 	triangulate2d(V::Points, EV::Cells)
"""
function triangulate2d(V::Points, EV::Cells)
   	 # data for Constrained Delaunay Triangulation (CDT)
   	points = convert(Array{Float64,2}, V')
	trias = constrained_triangulation2D(V::Points, EV::Cells)

 	#Triangle.constrained_triangulation(points,points_map,edges_list)
	innertriangles = Array{Int64,1}[]
	for (u,v,w) in trias
		point = (points[u,:]+points[v,:]+points[w,:])./3
		copEV = characteristicMatrix(EV)
		inner = point_in_face(point, points::Points, copEV::ChainOp)
		if inner
			push!(innertriangles,[u,v,w])
		end
	end
    return innertriangles
end


"""
	removeDups(CW::Cells)::Cells

Remove dublicate `cells` from `Cells` object. Then put `Cells` in *canonical form*, i.e. with *sorted indices* of vertices in each (unique) `Cells` Array element.
"""
function removeDups(CW::Cells)::Cells
	CW = collect(Set(CW))
	CWs = collect(map(sort,CW))
	return CWs
end

"""
	struct2lar(structure::Struct)::Union{LAR,LARmodel}

"""
function struct2lar(structure) # TODO: extend to true `LARmodels`
	listOfModels = evalStruct(structure)
	vertDict= Dict()
	index,defaultValue = 0,0
	W = Array{Float64,1}[]
	m = length(listOfModels[1])
	larmodel = [Array{Number,1}[] for k=1:m]

	for model in listOfModels
		V = model[1]
		for k=2:m
			for incell in model[k]
				outcell=[]
				for v in incell
					key = map(approxVal(7), V[:,v])
					if get(vertDict,key,defaultValue)==defaultValue
						index += 1
						vertDict[key]=index
						push!(outcell,index)
						push!(W,key)
					else
						push!(outcell,vertDict[key])
					end
				end
				append!(larmodel[k],[outcell])
			end
		end
	end

	append!(larmodel[1], W)
	V = hcat(larmodel[1]...)
	chains = [convert(Cells, chain) for chain in larmodel[2:end]]
	return (V, chains...)
end

"""
	embedTraversal(cloned::Struct,obj::Struct,n::Int,suffix::String)

# TODO:  debug embedTraversal
"""
function embedTraversal(cloned::Struct,obj::Struct,n::Int,suffix::String)
	for i=1:length(obj.body)
		if isa(obj.body[i],Matrix)
			mat = obj.body[i]
			d,d = size(mat)
			newMat = Matrix{Float64}(LinearAlgebra.I, d+n, d+n)
			for h in range(1, length=d)
				for k in range(1, length=d)
					newMat[h,k]=mat[h,k]
				end
			end
			push!(cloned.body,[newMat])
		elseif (isa(obj.body[i],Tuple) ||isa(obj.body[i],Array))&& length(obj.body[i])==3
			V,FV,EV = deepcopy(obj.body[i])
			dimadd = n
			ncols = size(V,2)
			nmat = zeros(dimadd,ncols)
			V = [V;zeros(dimadd,ncols)]
			push!(cloned.body,[(V,FV,EV)])
		elseif  (isa(obj.body[i],Tuple) ||isa(obj.body[i],Array))&& length(obj.body[i])==2
			V,EV = deepcopy(obj.body[i])
			dimadd = n
			ncols = size(V,2)
			nmat = zeros(dimadd,ncols)
			V = [V;zeros(dimadd,ncols)]
			push!(cloned.body,[(V,EV)])
		elseif isa(obj.body[i],Struct)
			newObj = Struct()
			newObj.box = [ [obj.body[i].box[1];zeros(dimadd)],
							[obj.body[i].box[2];zeros(dimadd)] ]
			newObj.category = (obj.body[i]).category
			push!(cloned.body,[embedTraversal(newObj,obj.body[i],obj.dim+n,suffix)])
		end
	end
	return cloned
end

"""
	embedStruct(n::Int)(self::Struct,suffix::String="New")

# TODO:  debug embedStruct
"""
function embedStruct(n::Int)
	function embedStruct0(self::Struct,suffix::String="New")
		if n==0
			return self, length(self.box[1])
		end
		cloned = Struct()
		cloned.box = [ [self.body[i].box[1];zeros(dimadd)],
						[self.body[i].box[2];zeros(dimadd)] ]
		cloned.name = self.name*suffix
		cloned.category = self.category
		cloned.dim = self.dim+n
		cloned = embedTraversal(cloned,self,n,suffix)
		return cloned
	end
	return embedStruct0
end

"""
	box(model)

"""
function box(model)
	if isa(model,Matrix)
		return nothing
	elseif isa(model,Struct)
		listOfModels = evalStruct(model)
		#dim = checkStruct(listOfModels)
		if listOfModels == []
			return model.box
		else
			theMin,theMax = box(listOfModels[1])
			for theModel in listOfModels[2:end]
				modelMin,modelMax= box(theModel)
				for (k,val) in enumerate(modelMin)
					if val < theMin[k]
						theMin[k]=val
					end
				end
				for (k,val) in enumerate(modelMax)
					if val > theMax[k]
						theMax[k]=val
					end
				end
			end
		end
		return [theMin,theMax]

	elseif (isa(model,Tuple) ||isa(model,Array))&& (length(model)>=2)
		V = model[1]
		theMin = minimum(V, dims=2)
		theMax = maximum(V, dims=2)
	end

	return [theMin,theMax]
end

"""
	apply(affineMatrix::Array{Float64,2}, larmodel::Union{LAR,LARmodel})
"""
function apply(affineMatrix, larmodel)
	data = collect(larmodel)
	V = data[1]

	m,n = size(V)
	W = [V; fill(1.0, (1,n))]
	V = (affineMatrix * W)[1:m,1:n]

	data[1] = V
	larmodel = Tuple(data)
	return larmodel
end


"""
	checkStruct(lst)

"""
function checkStruct(lst)
	obj = lst[1]
	if isa(obj,Matrix)
		dim = size(obj,1)-1
	elseif (isa(obj,Tuple) || isa(obj,Array))
		dim = length(obj[1][:,1])

	elseif isa(obj,Struct)
		dim = length(obj.box[1])
	end
	return dim
end

"""
	traversal(CTM,stack,obj,scene=[])

"""
function traversal(CTM::Matrix, stack, obj, scene=[])
	for i = 1:length(obj.body)
		if isa(obj.body[i],Matrix)
			CTM = CTM*obj.body[i]
		elseif (isa(obj.body[i],Tuple) || isa(obj.body[i],Array)) &&
			(length(obj.body[i])>=2)
			l = apply(CTM, obj.body[i])
			push!(scene,l)
		elseif isa(obj.body[i],Struct)
			push!(stack,CTM)
			traversal(CTM,stack,obj.body[i],scene)
			CTM = pop!(stack)
		end
	end
	return scene
end

"""
	evalStruct(self)

"""
function evalStruct(self::Struct)
	dim = checkStruct(self.body)
   	CTM, stack = Matrix{Float64}(LinearAlgebra.I, dim+1, dim+1), []
   	scene = traversal(CTM, stack, self, [])
	return scene
end
