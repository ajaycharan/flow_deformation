%===============================================================
% function B = sologm(R)
% - input: R
%       R : R matrix in SO(3)
% - output: B
%       B : matrix logarithm of R, a matrix in so(3)
%===============================================================
function B = sologm(R)

% tolerance (for lambda and theta comparisons)
tau = 8;

% compute theta
theta = acos((trace(R) - 1) / 2);
theta = round(theta, tau);

% compute B
B = zeros(3);

 % no rotation
if theta == 0
    B = zeros(3);

% non integer multiple of pi
elseif (0 < theta) && (theta < pi) 
    B = (theta / (2 * sin(theta))) * (R - R');

% odd multiple of pi
elseif theta == pi 
    S = .5 * (R - eye(3));
    B = compute_ssm(S);
end

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
