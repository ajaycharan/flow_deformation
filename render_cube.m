function render_cube(cube, A)

% convert vertices to homogenous coordinates
X = cube.vertices;
X = [X'; ones(1, length(cube.vertices))];

% apply transformation
Y = A * X;

% convert back 
V = Y(1:end-1, :)';

% plot original
patch('Vertices', cube.vertices, 'Faces', cube.faces, ...
'FaceVertexCData', hsv(6), 'FaceColor', 'flat');
view(3);

% plot new
patch('Vertices', V, 'Faces', cube.faces, ...
'FaceVertexCData', hsv(6), 'FaceColor', 'flat');
view(3);

axis vis3d;
axis equal;

