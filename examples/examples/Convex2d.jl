using Visualization

points = rand(100,2)
Visualization.VIEW([
  Visualization.GLHull2d(points),
  Visualization.GLPoints(points),
  Visualization.GLFrame2
]);
