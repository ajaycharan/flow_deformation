%===============================================================
% function A = simexpm(B)
% - input: B
%       B : a matrix in sim(3)
% - output: A
%       A : matrix exponential of B, a matrix in SIM(3)
%===============================================================
function A = simexpm(B)

% tolerance (for lambda and theta comparisons)
tau = 8;

% extract lambda
lambda = B(1, 1);
lambda = round(lambda, tau);

% extract Omega
Omega = B(1:3, 1:3) - lambda * eye(3);

% extract W
W = B(1:3, end);

% compute theta
theta = sqrt( Omega(3, 2)^2 + Omega(1, 3)^2 + Omega(2, 1)^2 );
theta = round(theta, tau);

% compute rotation and scale
sR = [];
if theta == 0
    sR = exp(lambda) * eye(3);
else
    sR = exp(lambda) * ...
    (eye(3) + (sin(theta)/theta) * Omega + ((1-cos(theta))/theta^2) * Omega^2);
end


% compute V
V = zeros(3);

if theta == 0 && lambda == 0
    V = eye(3);

elseif theta == 0 && lambda ~= 0
    V = ((exp(lambda) - 1) / lambda) * eye(3);

elseif theta ~= 0 && lambda == 0
    V = eye(3) ...
    + ((1 - cos(theta)) / theta^2) * Omega ...
    + ((theta - sin(theta)) / theta^3) * Omega^2;

elseif theta ~= 0 && lambda ~= 0
    a = (exp(lambda) - 1) / lambda;
    b = (theta * (1 - exp(lambda) * cos(theta)) ...
        + exp(lambda) * lambda * sin(theta)) / (theta * (lambda^2 + theta^2));
    c = ((exp(lambda) - 1) / (lambda * theta^2)) ...
        - ((exp(lambda) * sin(theta)) / (theta * (lambda^2 + theta^2))) ...
        - (lambda * (exp(lambda) * cos(theta) - 1) / (theta^2 * (lambda^2 + theta^2)));
    V =  a * eye(3) + b * Omega + c * Omega^2;

end

% compute A
A = zeros(4);
A(1:3, 1:3) = sR;
A(1:3, end) = V * W;
A(end, end) = 1;

end

