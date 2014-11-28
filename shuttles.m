function [] = shuttles()
%SHUTTLES Charged shuttle simulation program.
%   Simulates the dynamics of conductive spheres bouncing between two
%   oppositively charged planes in 2D.

global l
global as;
global qs;
global pairs;
global mu;

ns = 2;         % number of spheres
l = [ 20 10 ];  % channel dimensions
as = 1;         % Van der Waals (not used yet)
qs = 1;         % charge
mu = 1 / (6 * pi)^2; % dynamic viscosity coefficient

% Array storing indexes of spheres in each pair, e.g. pairs(1,:) = [1 2],
% pairs(2,:) = [1 3], and so on.
pairs = zeros(ns * (ns - 1) / 2, 2);
idx = 1;
for a = 1:ns-1
    for b = a+1:ns
        pairs(idx, 1) = a;
        pairs(idx, 2) = b;
        idx = idx + 1;
    end
end

% Initialize the system.
%
% Following arrays are used to define the system state:
% (a) r - particle positions stored as [x1, y1, x2, y2, ..., xN, yN];
% (b) v - particle velocities stored as [vx1, vy1, vx2, vy2, ..., vxN, vyN]
% (c) q - particle charges;
% (d) s - particle diameters.
%
% Spheres are placed at random across the channel. Currently, all spheres
% have the same diameter 's' equal 2a.
[r0, q, s] = setup(ns, l);

% Caculate initial forces and velocities.
v0 = velocity(0, r0, s, q);
f0 = force(0, r0, s, q);

draw(r0, v0, s, q)
pause;

tini = 0;
tfin = 10;
tout = [ tini ];
rout = [ r0' ];
teout = [];
reout = [];
qout = [ q' ];

nc = 0;
tcoll = [];
qcoll = [];

options = odeset('Events', @(t, r) incidents(t, r, s), 'RelTol', 1e-3);
while tini < tfin
    % Solve until first terminal event is encoutered.
    if ns == 1
        [t, r, te, re, ie] = ...
            ode45(@(t, r) velocity(t, r, s, q), [tini tfin], r0, options);
    else
        [t, r, te, re, ie] = ...
            ode15s(@(t, r) velocity(t, r, s, q), [tini tfin], r0, options);
    end
    
    % Save trajectories.
    nt = length(t);
    tout = [tout; t(2:nt)];
    rout = [rout; r(2:nt,:)];
    
    qout = [qout; repmat(q', nt - 1, 1)];
    
    teout = [teout; te];
    reout = [reout; re];
    
    % Update particle positions or charges according to event type.
    if te     
        % Count collisions with upper wall.
        n = length(re);
        if ie <= n && mod(ie, 2) == 0
            dwall = re(2:2:n)' - (l(2) - 0.5 * s(:));
            idx = find(abs(dwall) < 1.0e-03);
            if ~isempty(idx)
                tcoll = [tcoll; te];
                qcoll = [qcoll; q(idx)];
                nc = nc + length(idx);
            end
        end
        
        [r0, q] = response(te, ie, r(end,:)', s, q);
    end
    tini = t(end);
end

dt = 0.01;
t = 0:dt:tfin;
r = interp1(tout, rout, t);
q = interp1(tout, qout, t, 'nearest');

v = zeros(length(t), 2 * ns);
f = zeros(length(t), 2 * ns);
v(1,:) = v0;
f(1,:) = f0;
for i = 2:length(t)
    if ns == 1
        v(i,:) = velocity(t(i), r(i,:)', s, q(i)');
        f(i,:) = force(t(i), r(i,:)', s, q(i)');
    else
        v(i,:) = velocity(t(i), r(i,:)', s, q(i,:)');
        f(i,:) = force(t(i), r(i,:)', s, q(i,:)');
    end
end

for i = 1:size(r, 1)
    if ns == 1
        draw(r(i,:), v(i,:), s, q(i))
    else
        draw(r(i,:), v(i,:), s, q(i,:))
    end
    pause(0.01)
end

fp = fopen('data.dat', 'w');
for i = 1:length(t)
    fprintf(fp, '%15.7f', t(i));
    
    for j = 1:length(r(i,:))
        fprintf(fp, '%15.7f', r(i, j));
    end
    
    for j = 1:length(v(i,:))
        fprintf(fp, '%15.7f', v(i, j));
    end
    
    for j = 1:length(f(i,:))
        fprintf(fp, '%15.7f', f(i, j));
    end
    
    if ns == 1
        fprintf(fp, '%15.7f', q(i));
    else
        for j = 1:length(q(i,:))
            fprintf(fp, '%15.7f', q(i, j));
        end
    end
    fprintf(fp, '\n');
end
fclose(fp);

fp = fopen('current.dat', 'w');
for i = 1:length(tcoll)
    fprintf(fp, '%15.7f%15.7f\n', tcoll(i), qcoll(i));
end
fclose(fp);

end