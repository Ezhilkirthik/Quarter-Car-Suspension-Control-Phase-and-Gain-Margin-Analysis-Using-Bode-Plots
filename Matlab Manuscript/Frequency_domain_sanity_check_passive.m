% (reuse your ms,mu,ks,cs,kt,ct)
A = [0 1 0 0;
    -ks/ms -cs/ms  ks/ms     cs/ms;
     0 0 0 1;
     ks/mu cs/mu  -(ks+kt)/mu  -(cs+ct)/mu];
B = [0;0;0; kt/mu]; C = [1 0 0 0]; D = 0;
sys = ss(A,B,C,D);

figure; bode(sys); grid on; title('zr→zs Bode');
[GM,PM] = margin(sys); disp([GM,PM])
figure; pzmap(sys); grid on

[wn,zeta] = damp(sys);
fn = wn/(2*pi);
table(fn, zeta, 'VariableNames', {'NaturalFreq_Hz','DampingRatio'})
