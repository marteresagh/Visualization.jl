const Points = Matrix # a single point is a Vector
const Point = Vector # a single point is a Vector
const Cells = Array{Array{Int,1},1}
const LAR = Union{ Tuple{Points, Cells},Tuple{Points, Cells, Cells} }
const ChainOp = SparseArrays.SparseMatrixCSC{Int8,Int}

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
