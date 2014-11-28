function r = dist(ri, rj)
%   DIST Returns separation vector between two particles.
%       Function returns the separation vector between particle $i$ and the
%       nearest image of particle $j$. Because of a slab geometry only $x$
%       coordinate is changed.
global l;

r = rj - ri;
r = r - l' .* [ fix(2 * r(1) / l(1)); 0 ];
end

