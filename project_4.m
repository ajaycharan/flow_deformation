% cleanup
clear all;
close all;

% data
[D, P] = load_quad_data;

% downsample similitudes
freq = 20;
D = D(:, :, 1:freq:end);

% interpolation end condition
cond = 'natural';

% number of subdivisions
N = 3;

% set up figure
plot3(P(:, 1), P(:, 2), P(:, 3), '-r');
h = get(gca, 'DataAspectRatio');
set(gca, 'DataAspectRatio', [1 1 h(3)]);
axis vis3d
hold on;

% cube and initialization
cube = load_cube(D(:, :, 1));

% generate deformation vectors
X = [];
for i=1:size(D, 3)
    
    % compute logarithm of similitude
    B = simlogm(D(:, :, i));

    % extract parameters
    lambda = B(1, 1);
    a = B(3, 2);
    b = B(1, 3);
    c = B(2, 1);
    W = B(1:3, end);

    % create vector
    x = [lambda, a, b, c, W'];

    % append 
    X = [X; x];

end

% compute control points
C = curveinterp(X, cond);

% compute spline curve
S = b_spline(C, N);

% convert spline vector to matrix
D = [];
for i=1:length(S)

    % extract paramters
    lambda = S(i, 1);
    a = S(i, 2);
    b = S(i, 3);
    c = S(i, 4);
    W = S(i, 5:end)';

    % convert to matrix
    B = zeros(4);
    B(3, 2) = a;
    B(1, 3) = b;
    B(2, 1) = c;
    B = B-B';
    B(1:3, 1:3) = B(1:3, 1:3) + lambda * eye(3);
    B(1:3, end) = W;
    B(end, end) = 1;

    % exponentiate
    A = simexpm(B);

    % append
    D = cat(3, D, A);

end

% animation
for i=1:size(D, 3)

    % draw
    render_cube(cube, D(:, :, i));

    drawnow;
    pause(0.01);
end
