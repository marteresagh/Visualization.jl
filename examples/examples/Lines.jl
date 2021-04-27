using Visualization


points,lines = Visualization.text("PLaSM")
Visualization.VIEW([
      Visualization.GLFrame2
      Visualization.GLLines(points,lines)
]);
