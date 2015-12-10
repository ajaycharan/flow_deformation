function B = simlogm(A)

% tolerance (for lambda and theta comparisons)
tau = 8;

% compute alpha from the eigs of the similtude
E = eig(A(1:3, 1:3));
alpha = nthroot(prod(E), 3);

% compute the rotation
R = A(1:3, 1:3) / alpha;

% compute lambda
lambda = log(alpha);
lambda = round(lambda, tau);

% compute theta
theta = acos((trace(R) - 1) / 2);
theta = round(theta, tau);

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

% compute W
W = inv(V) * A(1:3, end);

% compute B
B = zeros(4);
B(1:3, 1:3) = lambda * eye(3) + Omega;
B(1:3, end) = W;

end

function U = compute_ssm(S)

% vector of b, c, d
x = zeros(3, 1);

% vectorize diagonal and add 1
d = diag(S) + 1;

% find first nonzero root
id = find(d, 1);
r = sqrt(d(id));

% compute final b, c, d
x(id) = r;
y = S(id, :)';
y(id) = 0;
x = x + y / r;

% generate matrix
b = x(1);
c = x(2);
d = x(3);

U = [0, -d, c; d, 0, -b; -c, b, 0];

end
