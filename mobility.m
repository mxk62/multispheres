function M = mobility(r)
% MOBILITY  Calculates mobility matrix.

n = length(r) / 2;
M = zeros(2 * n);
for a = 1:n
    i = 2 * a - 1;
    for b = 1:n
        j = 2 * b - 1;
        rab = dist(r(i:i+1), r(j:j+1));
        M(i:i+1, j:j+1) = pairmobility(a, b, rab);
    end
end
end

function A = pairmobility(a, b, r)
% PAIRMOBILITY  Calculates individal submatrices in mobility matrix.

if a == b
    e = [ 0 0 ];
    x = 1;
    y = 1;
else
    d = norm(r);    
    assert(d > 0, 'Zeroth vector encoutered.')
    e = r / d;    
    x = 3 / (2 * d) - 1 / d^3;
    y = 3 / (4 * d) + 1 / (2 * d^3);
end

A = zeros(2, 2);
for i = 1:2
    for j = 1:2
        A(i, j) = x * e(i) * e(j) + y * ((i == j) - e(i) * e(j));
    end
end
end