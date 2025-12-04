% Passive state-space (zr -> zs), as before:
A = [0 1 0 0;
    -ks/ms -cs/ms  ks/ms     cs/ms;
     0 0 0 1;
     ks/mu cs/mu -(ks+kt)/mu -(cs+ct)/mu];
Bz = [0;0;0; kt/mu];   % road input
C  = [1 0 0 0]; D = 0;

% Skyhook closed-loop A: A_cl = A - Bu * c_sky * [0 1 0 0]
Bu  = [0; 1/ms; 0; 0];
c_sky = 2000;
A_cl = A - Bu * (c_sky*[0 1 0 0]);

sysP  = ss(A,Bz,C,D);
sysSH = ss(A_cl,Bz,C,D);

figure; bode(sysSH); grid on;
legend('Skyhook'); title('Bode: zr → zs (Skyhook)');
