function v = velocity(t, r, s, q)
%VELOCITY Calulcates velocity of each particle.

global mu;

% Calculate mobility matrix for a given configuration of particles.
M = mobility(r);

% Calculate external deterministic forces actinng on each particle.
f = force(t, r, s, q);

% Include sphere-wall interactions (image spheres)
f = wall(r, f);

v = M * f / (6 * pi * mu);
end