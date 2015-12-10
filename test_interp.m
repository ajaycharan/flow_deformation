
clear all;
close all;

% data
[D, P] = load_quad_data;

% setup figure
f = figure;
h = get(gca, 'DataAspectRatio');
set(gca, 'DataAspectRatio', [1 1 h(3)]);
axis vis3d
hold on;

% cube and initialization
cube = load_cube(D(:, :, 1));

% index
id = 1

% draw interpolation between t = [0, 1]
res = 10
for i=1:res

    % render
    render_cube(cube, D(:, :, id));
    render_cube(cube, D(:, :, id + 1));
    render_cube(cube, deforminterp(D(:, :, id), D(:, :, id+1), i / res));

    drawnow;
    pause(0.1);
end


