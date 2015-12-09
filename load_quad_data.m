function [D, P] = load_quad_data()

% load similtudes
data = load('./data/similtudes.mat');
D = data.similtudes;
D = permute(D, [2 3 1]);

% load odometry
P = dlmread('./data/odometry.dat');
