function cube = load_cube(A_0)

% basic 
vertices = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1];

% jimmie it around
scale = .1;
vertices(:, 1)  = vertices(:, 1) - 0.5;
vertices(:, 2)  = vertices(:, 2) - 0.5;
vertices(:, 3)  = vertices(:, 3) - 0.5;
vertices = scale * vertices;

faces = [1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8];
cube = struct('vertices', vertices, 'faces', faces);

