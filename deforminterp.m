function A = deforminterp(A_1, A_2, t)

if nargin < 3
    t = .5;
end

% compute logarithm
B_1 = simlogm(A_1);
B_2 = simlogm(A_2);

% interpolation
B = (1 - t) * B_1 + t * B_2;

% re-exponentiate
A = simexpm(B);

end

