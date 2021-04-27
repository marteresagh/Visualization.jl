using Test
using Visualization

@testset "Box.jl" begin

   # 	function Box3d()
   @testset "Box3d()" begin
      @test typeof(Visualization.Box3d())==Visualization.Box3d
      @test Visualization.Box3d().p1==[0.0,0.0,0.0]
      @test Visualization.Box3d().p2==[0.0,0.0,0.0]
      @test typeof(Visualization.Box3d().p1)==Visualization.StaticArrays.MArray{Tuple{3},Float64,1,3}
      @test typeof(Visualization.Box3d().p2)==Visualization.StaticArrays.MArray{Tuple{3},Float64,1,3}
      # function Box3d(p1::Point3d,p2::Point3d)
      p1=Visualization.Point3d(-1,-1,-1); p2=Visualization.Point3d(+1,+1,+1);
      @test Visualization.Box3d(p1,p2)==Visualization.Box3d(Visualization.Point3d(-1.0, -1.0, -1.0), Visualization.Point3d(1.0, 1.0, 1.0))
      @test typeof(Visualization.Box3d)==DataType
   end

   # function invalidBox()
   @testset "invalidBox()" begin
      @test Visualization.invalidBox()==Visualization.Box3d(Visualization.Point3d(Inf,Inf,Inf),Visualization.Point3d(-Inf,-Inf,-Inf))
      @test Visualization.invalidBox().p1==Visualization.Point3d(Inf,Inf,Inf)
      @test Visualization.invalidBox().p2==Visualization.Point3d(-Inf,-Inf,-Inf)
      @test typeof(Visualization.invalidBox().p1)==Visualization.StaticArrays.MArray{Tuple{3},Float64,1,3}
   end


   # function addPoint(box::Box3d,point::Point3d)
   @testset "addPoint" begin
      box=Visualization.invalidBox(); point=Visualization.Point3d(0,0,0)
      @test typeof(Visualization.addPoint(box,point))==Visualization.Box3d
      @test Visualization.addPoint(Visualization.Box3d(),Visualization.Point3d(0,0,1))==Visualization.Box3d(Visualization.Point3d(0.0,0.0,0.0),Visualization.Point3d(0.0,0.0,1.0))
      @test typeof(Visualization.addPoint(Visualization.Box3d(),Visualization.Point3d(0,0,1)))==Visualization.Box3d
   end


   # function getPoints(box::Box3d)
   a = Visualization.addPoint(Visualization.Box3d(),Visualization.Point3d(0,0,1))
   Visualization.addPoint(a,Visualization.Point3d(1,0,1))
   Visualization.addPoint(a,Visualization.Point3d(0,1,1))
   @testset "getPoints" begin
      @test a==Visualization.Box3d(Visualization.Point3d(0.0,0.0,0.0), Visualization.Point3d(1.0,1.0,1.0))
      box = Visualization.getPoints(Visualization.Box3d(Visualization.Point3d(0,0,0),Visualization.Point3d(1,1,1)))
      @test typeof(box)==Array{Visualization.MArray{Tuple{3},Float64,1,3},1}
      @test box==convert(Array{Visualization.MArray{Tuple{3},Float64,1,3},1},[[0.0, 0.0, 0.0],
                             [1.0, 0.0, 0.0],
                             [1.0, 1.0, 0.0],
                             [0.0, 1.0, 0.0],
                             [0.0, 0.0, 1.0],
                             [1.0, 0.0, 1.0],
                             [1.0, 1.0, 1.0],
                             [0.0, 1.0, 1.0]])
   end
end
