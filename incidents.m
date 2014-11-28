function [value, isterminal, direction] = incidents(t, r, s)
%INCIDENTS Defines possible events which may occur in the system.
%   It locates incidents like: boundary crossing, sphere-wall collisions,
%   and sphere-sphere collisions. In case of any event, integration is
%   stopped.

global l;

n = length(r);
nsph = n / 2;
npair = nsph * (nsph - 1) / 2;

% Initialize event arrays.
value = zeros(n + npair, 1);
direction = zeros(n + npair, 1);
isterminal = ones(n + npair, 1);

% Periodic boundary crossing.
value(1:2:n) = r(1:2:n) .* (r(1:2:n) - l(1));
direction(1:2:n) = ones(n/2, 1);

% Collision with a wall.
value(2:2:n) = (r(2:2:n) - 0.5 * s(:)) .* (r(2:2:n) - (l(2) - 0.5 * s(:)));
direction(2:2:n) = ones(n/2, 1);

% Collsion with other spehere.
idx = n + 1;
for a = 1:nsph-1
    i = 2 * a - 1;
    for b = a+1:nsph
        j = 2 * b - 1;
        rab = dist(r(i:i+1), r(j:j+1));        
        value(idx) = norm(rab) - (s(a) + s(b))/2;
        idx = idx + 1;
    end
end
direction(n + 1:end) = -ones(npair, 1);
end