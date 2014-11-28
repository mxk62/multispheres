function draw(r, v, s, q)
% DRAW  Draws snapshot of the system configuration
%   Detailed explanation goes here
global l;

n = length(r) / 2;
for a = 1:n
    rad = s(a) / 2;
   
    i = 2 * a - 1;
    if q(a) > 0
        style = '-r';
    elseif q(a) == 0
        style = '-k';     
    else 
        style = '-b';
    end
    
    part(r(i:i+1), rad, style);
    hold on;
    
    label = sprintf('%.2f', q(a));
    text(r(i), r(i+1), label, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    hold on;
    
    %quiver(r(i), r(i+1), v(i), v(i+1), '-k');   
end

axis equal;
axis ([ 0 l(1) 0 l(2) ]);
hold off;
end

function part(r, radius, style)
% PARTICLE  Draws representation of the particle
%   Fucntion draws a cricle of radius 'rad' centerd in 'r' using
%   supplied user supplied style 'style'.

nsample = 100;
phi = linspace(0, 2 * pi, nsample);
[x y] = pol2cart(phi, radius);
plot(x(:) + r(1), y(:) + r(2), style);
end