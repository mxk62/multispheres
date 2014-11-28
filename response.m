function [re, q] = response(te, ie, re, s, q)
%RESPONSE Governs the responce of the system if an event occurs.

global l;
global qs;
global pairs;

n = length(re);
nsph = n / 2;
ne = length(ie);
for i = 1:ne
    idx = ie(i);
    if idx <= n
        if mod(idx, 2) == 1
            % periodic boundary crossing
            re(idx) = l(1) - re(idx);
        else
            % collision with a wall
            a = idx / 2;
            q(a) = qs * (l(2) - 2 * re(idx)) / (l(2) - s(a));
        end
    else
        % collision between a pair of sphere
        idx = idx - n;
        a = pairs(idx, 1);
        b = pairs(idx, 2);
        ia = 2 * a - 1;
        ib = 2 * b - 1;
        
        rab = dist(re(ia:ia+1), re(ib:ib+1));
        eab = rab / norm(rab);
        qtot = q(a) + q(b);
        q(a) = 0.5 * qtot - qs * dotprod(eab', [0; 1]);
        q(b) = 0.5 * qtot + qs * dotprod(eab', [0; 1]);  
    end
end
end