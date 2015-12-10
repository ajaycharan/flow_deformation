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
