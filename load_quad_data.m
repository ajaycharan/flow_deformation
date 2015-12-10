function [D, P] = load_quad_data()

% load similitudes
data = load('./data/similitudes.mat');
D = data.similitudes;
D = permute(D, [2 3 1]);

% load odometry
P = dlmread('./data/odometry.dat');
