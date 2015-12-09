clear all;

% load similtudes
data = load('./data/similtudes.mat');
D = data.similtudes;
D = permute(D, [2 3 1]);

% load odometry
P = dlmread('./data/odometry.dat');
