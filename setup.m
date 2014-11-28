function [r, q, s] = setup(n, l)
% INIT Initializes particle charges, diameters and positions.

global qs;


q = qs * ones(n, 1);
rnd = rand(n, 1);
for i = 1:n
    if rnd(i) < 0.5
        q(i) = -1;
    end
end

s = 2 * ones(n, 1);

r = zeros(2 * n, 1);
for a = 1:n
    laux = l - [ 0 s(a) ];
    i = 2 * a - 1;
    
    while 1
        isoverlap = 0;
        ra = rand(2, 1) .* laux' + [ 0; s(a)/2 ];
        
        for b = 1:a-1
            j = 2 * b - 1;
            rab = dist(r(j:j+1), ra);
            dab = sqrt(dotprod(rab, rab'));
            if dab < 0.5 * (s(a) + s(b))
                isoverlap = 1;
                break
            end
        end
        
        if ~isoverlap
            break;
        end
    end  
    r(i:i+1) = ra;
end
end