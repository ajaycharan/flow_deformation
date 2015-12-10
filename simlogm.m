function B = simlogm(A)

% compute alpha from the eigs of the similtude
E = eig(A(1:3, 1:3));
alpha = nthroot(prod(E), 3);

% compute the rotation
R = A(1:3, 1:3) / alpha;

% compute lambda
lambda = log(alpha);

% compute theta
theta = acos((trace(R) - 1) / 2);

% compute Omega
Omega = zeros(3);

 % no rotation
if theta == 0
    Omega = zeros(3);

% non integer multiple of pi
elseif (0 < theta) && (theta < pi) 
    Omega = (theta / (2 * sin(theta))) * (R - R');

% odd multiple of pi
elseif theta == pi 
    S = .5 * (R - eye(3));
    Omega = compute_ssm(S);
end

% compute V
V = zeros(3);

if theta == 0 && lambda == 0
    disp('theta zero, lambda zero');
    V = eye(3);

elseif theta == 0 && lambda ~= 0
    disp('theta zero, lambda not zero');
    V = ((exp(lambda) - 1) / lambda) * eye(3);

elseif theta ~= 0 && lambda == 0
    disp('theta not zero, lambda zero');
    V = eye(3) ...
    + ((1 - cos(theta)) / theta^2) * Omega ...
    + ((theta - sin(theta)) / theta^3) * Omega^2;

elseif theta ~= 0 && lambda ~= 0
    disp('both zero');
    a = (exp(lambda) - 1) / lambda;
    b = (theta * (1 - exp(lambda) * cos(theta)) ...
        + exp(lambda) * lambda * sin(theta)) / (theta * (lambda^2 + theta^2));
    c = ((exp(lambda) - 1) / (lambda * theta^2)) ...
        - ((exp(lambda) * sin(theta)) / (theta * (lambda^2 + theta^2))) ...
        - (lambda * (exp(lambda) * cos(theta) - 1) / (theta^2 * (lambda^2 + theta^2)));
    V =  a * eye(3) + b * Omega + c * Omega^2;

end

% compute W
W = inv(V) * A(1:3, end);

% compute B
B = zeros(4);
B(1:3, 1:3) = lambda * eye(3) + Omega;
B(1:3, end) = W;

end

