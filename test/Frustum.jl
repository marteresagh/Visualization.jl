@testset "Frustum.jl" begin

   mesh = Visualization.GLCuboid(Visualization.Box3d(Visualization.Point3d(0,0,0),Visualization.Point3d(1,1,1)))
   Visualization.VIEW([mesh],false);
   viewport=[0,0,Visualization.viewer.W,Visualization.viewer.H];
   projection =Visualization.getProjection(Visualization.viewer);
   modelview=Visualization.getModelview(Visualization.viewer);
   themap=Visualization.FrustumMap(viewport,projection,modelview)

   @testset "projectPoint" begin
      @test Visualization.projectPoint(themap::Visualization.FrustumMap,Visualization.Point3d(1.5,1.5,1.5))==Visualization.Point3d(512.0, 384.0, 0.9865771471158417)
      @test Visualization.projectPoint(themap::Visualization.FrustumMap,Visualization.Point3d(-1.5,-1.5,-1.5))==Visualization.Point3d(512.0, 384.0,0.9968617210493019)
      @test typeof(Visualization.projectPoint(themap::Visualization.FrustumMap,Visualization.Point3d(1.5,1.5,1.5)))==Visualization.StaticArrays.MArray{Tuple{3},Float64,1,3}
      @test typeof(themap)==Visualization.FrustumMap
      @test typeof(Visualization.Point3d(1.5,1.5,1.5))==Visualization.StaticArrays.MArray{Tuple{3},Float64,1,3}
    end

   @testset "unprojectPoint" begin
      x=1.5; y=1.5; z=1.5;
      p4 = (themap.inv_modelview * (themap.inv_projection * (themap.inv_viewport * Visualization.Point4d(x,y,z, 1.0))))
      @test typeof(themap)==Visualization.FrustumMap
      @test Visualization.Point4d(x,y,z, 1.0)==[1.5,1.5,1.5,1.0]
      @test p4 == [-37.0748323866816,-38.160305054815986,-38.32191336607133,-12.425000000000002]
   end

end
