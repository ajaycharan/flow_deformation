
clear all;
close all;

figure;
xlim([-40 20])
ylim([-40 20])
zlim([0 10])

h = get(gca, 'DataAspectRatio');
set(gca, 'DataAspectRatio', [1 1 h(3)]);

hold on;

% data
[D, P] = load_quad_data;

% cube and initialization
cube = load_cube(D(:, :, 1));

for i=1:size(D, 3)

    % draw
    render_cube(cube, D(:, :, i));

    pause(0.1);
    cla;
end
