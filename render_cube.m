%===============================================================
% function render_cube(cube, A)
% - input: cube, A
%       cube : 3D cube object created with load_cube
%       A : Transformation to apply
% - output: None, renders transformed cube to a MATLAB figure
%===============================================================
function render_cube(cube, A)

% convert vertices to homogenous coordinates
X = cube.vertices;
X = [X'; ones(1, length(cube.vertices))];

% apply transformation
Y = A * X;

% convert back 
V = Y(1:end-1, :)';

% plot
patch('Vertices', V, 'Faces', cube.faces, ...
'FaceVertexCData', hsv(6), 'FaceColor', 'flat');
view(3);

