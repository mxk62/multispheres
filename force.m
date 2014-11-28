function f = force(t, r, s, q)
%FORCE Calculates net forces acting on particles.

n = length(r) / 2;

% Calculate interparticle interactions.
f = zeros(2 * n, 1);
for a = 1:n-1
    i = 2 * a - 1;
    for b = a+1:n
       j = 2 * b - 1;
       rab = dist(r(i:i+1), r(j:j+1));
       f(i:i+1) = f(i:i+1) + fc(rab, q(a), q(b));
       f(j:j+1) = f(j:j+1) - f(i:i+1);
    end
end

% Add any external, deterministic forces acting on particles.
for a = 1:n
    i = 2 * a - 1;
    f(i:i+1) = f(i:i+1) + fe(q(a));
end

end


function f = fc(rij, qi, qj)
%FC Calculates Coulomb force between two charges.

dij = norm(rij);
f = -qi * qj / dij^3 * rij;
end


function f = fe(q)
%FE Calculates force due to an electric field applied.
f = q * [0; 1];
end