%% ================= PASSIVE vs SKYHOOK COMPARISON ======================
% Run Passive (c_sky = 0) and one Skyhook case (set c_sky_val)
c_sky_val = 2000;                           % <— pick your tuned value

% --- Passive
c_sky = 0; assignin('base','c_sky',c_sky);
simP = sim(model,'StopTime',num2str(tstop));
zsP   = simP.get('zs_ts');  zuP   = simP.get('zu_ts');
accP  = simP.get('accs_ts');suspP = simP.get('susp_ts');

% --- Skyhook
c_sky = c_sky_val; assignin('base','c_sky',c_sky);
simS = sim(model,'StopTime',num2str(tstop));
zsS   = simS.get('zs_ts');  zuS   = simS.get('zu_ts');
accS  = simS.get('accs_ts');suspS = simS.get('susp_ts');

% -------------------- Metrics table --------------------
rmsP  = rms(accP.Data);   rmsS  = rms(accS.Data);
peakP = max(abs(accP.Data)); peakS = max(abs(accS.Data));
travP = max(abs(suspP.Data)); travS = max(abs(suspS.Data));

% settling time (2% band of max)
tsP = zsP.Time(find(abs(zsP.Data) < 0.02*max(abs(zsP.Data)),1,'last'));
tsS = zsS.Time(find(abs(zsS.Data) < 0.02*max(abs(zsS.Data)),1,'last'));

fprintf('\n=== Passive vs Skyhook (c_sky=%g) ===\n', c_sky_val);
fprintf('RMS(acc_s):   %.3f  →  %.3f  (%.1f%% better)\n', ...
        rmsP, rmsS, 100*(1 - rmsS/rmsP));
fprintf('Peak(acc_s):  %.3f  →  %.3f\n', peakP, peakS);
fprintf('Max travel:   %.4f  →  %.4f\n', travP, travS);
fprintf('Settling z_s: %.3fs → %.3fs\n', tsP, tsS);

% -------------------- Time-domain overlays --------------------
figure; plot(accP.Time,accP.Data); hold on; plot(accS.Time,accS.Data);
grid on; xlabel('Time (s)'); ylabel('m/s^2');
legend('Passive','Skyhook','Location','best');
title(sprintf('Body acceleration acc_s  (c_{sky}=%g)', c_sky_val));

figure; plot(zsP.Time,zsP.Data); hold on; plot(zsS.Time,zsS.Data);
grid on; xlabel('Time (s)'); ylabel('m');
legend('Passive','Skyhook','Location','best');
title('Body displacement z_s');

figure; plot(zuP.Time,zuP.Data); hold on; plot(zuS.Time,zuS.Data);
grid on; xlabel('Time (s)'); ylabel('m');
legend('Passive','Skyhook','Location','best');
title('Wheel displacement z_u');

figure; plot(suspP.Time,suspP.Data); hold on; plot(suspS.Time,suspS.Data);
grid on; xlabel('Time (s)'); ylabel('m');
legend('Passive','Skyhook','Location','best');
title('Suspension travel (z_s - z_u)');

% -------------------- Frequency-domain overlay --------------------
% Passive ss
A = [0 1 0 0;
    -ks/ms -cs/ms  ks/ms     cs/ms;
     0 0 0 1;
     ks/mu cs/mu -(ks+kt)/mu -(cs+ct)/mu];
Bz = [0;0;0; kt/mu]; C = [1 0 0 0]; D = 0;
sysP = ss(A,Bz,C,D);

% Skyhook closed-loop A (u = -c_sky*dot_zs)
Bu   = [0; 1/ms; 0; 0];
A_cl = A - Bu*(c_sky_val*[0 1 0 0]);
sysS = ss(A_cl,Bz,C,D);

% Bode
figure; bode(sysP); hold on; bode(sysS); grid on;
legend('Passive','Skyhook','Location','best');
title(sprintf('Bode: z_r \\rightarrow z_s  (c_{sky}=%g)', c_sky_val));

% Margins
[GMp,PMp,Wcgp,Wcpp] = margin(sysP);
[GMs,PMs,Wcgs,Wcps] = margin(sysS);
fprintf('\nMargins (Passive → Skyhook):\n');
fprintf('Gain Margin:  %.2f (%.2f dB) → %.2f (%.2f dB)\n', ...
        GMp, 20*log10(GMp), GMs, 20*log10(GMs));
fprintf('Phase Margin: %.2f deg       → %.2f deg\n', PMp, PMs);

% Optional: show natural freqs & damping
[wnP,zP] = damp(sysP); [wnS,zS] = damp(sysS);
fnP = wnP/2/pi; fnS = wnS/2/pi;
disp(table(fnP,zP,fnS,zS,'VariableNames', ...
    {'PassiveFreq_Hz','PassiveZeta','SkyhookFreq_Hz','SkyhookZeta'}));
