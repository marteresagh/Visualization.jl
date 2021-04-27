using Visualization

points = rand(50,3)
Visualization.VIEW([
      Visualization.GLPoints(points),
      Visualization.GLHull(points,Visualization.Point4d(1,1,1,0.2)),
      Visualization.GLAxis(Visualization.Point3d(0,0,0),Visualization.Point3d(1,1,1))
]);
