function cube = load_cube(A_0)

% basic 
vertices = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1];

% convert vertices to homogenous coordinates
X = [vertices'; ones(1, length(vertices))];

% apply transformation
Y = A_0 * X;

% convert back 
V = Y(1:end-1, :)';

faces = [1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8];
cube = struct('vertices', V, 'faces', faces);

