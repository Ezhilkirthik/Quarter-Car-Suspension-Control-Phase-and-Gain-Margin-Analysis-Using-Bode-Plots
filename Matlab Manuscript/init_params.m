% quarter car parameters (SI units)

ms = 300;    % sprung mass (kg)
mu = 40;     % unsprung mass (kg)
ks = 15000;  % suspension stiffness (N/m)
cs = 1000;   % suspension damping (N*s/m)
kt = 200000; % tire stiffness (N/m)
ct = 50;     % tire damping (N*s/m)

tstop = 20;  % stop time (s)
save('params.mat','ms','mu','ks','cs','kt','ct','tstop');
disp('Parameters initialized.');