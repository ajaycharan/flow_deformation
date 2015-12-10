%===============================================================
% function [D, P] = load_quad_data()
% - output: D, P
%       D : 4x4xN matrix containing similitudes from quad odometry,
%               uses Z for rotation scaling
%       P : The translational component of the quad odometry
%===============================================================
function [D, P] = load_quad_data()

% load similitudes
data = load('./data/similitudes.mat');
D = data.similitudes;
D = permute(D, [2 3 1]);

% load odometry
P = dlmread('./data/odometry.dat');
