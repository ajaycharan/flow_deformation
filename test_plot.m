
clear all;
close all;

% data
[D, P] = load_quad_data;

f = figure;
plot3(P(:, 1), P(:, 2), P(:, 3));

h = get(gca, 'DataAspectRatio');
set(gca, 'DataAspectRatio', [1 1 h(3)]);
axis vis3d

hold on;


% cube and initialization
cube = load_cube(D(:, :, 1));

% path

for i=1:size(D, 3)

    % draw
    render_cube(cube, D(:, :, i));

    drawnow;
    pause(0.05);
end
