function fnet = wall(r, f)
%WALL Include sphere-wall interaction
%   Function corrects force acting an a sphere by including sphere-wall
%   interaction calculated using mirror image method.

global l

n = length(f);
fnet = f;
for i = 2:2:n
    dlower = 2 * r(i);
    dupper = 2 * (l(2) - r(i));
    fnet(i) = fnet(i) * (1 - 3 / (2 * dlower) + 1 / dlower^3 ...
            - 3 / (2 * dupper) + 1 / dupper^3);
end
end