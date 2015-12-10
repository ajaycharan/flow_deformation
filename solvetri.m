%===============================================================
% function x = solvetri(A, d)
% - input: A, d
%       A: tridiagonal matrix
%       d: result of A*x
% - output:
%       x: solution to system
%===============================================================
function x = solvetri(A, d)

% solve with LU factorization
[L, U, Delta] = lutri(A);
w = forwardsub(L * Delta, d);
x = backsub(inv(Delta) * U, w);
