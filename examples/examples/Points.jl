using Visualization

points = rand(10000,3)
Visualization.VIEW([
      Visualization.GLFrame,
      Visualization.GLPoints(points)
]);

points = rand(1000,2)
Visualization.VIEW([
      Visualization.GLFrame2,
      Visualization.GLPoints(points)
]);
