%% Quarter-car: run sim + pull logs safely
clc;

% Parameters (ensure they exist)
ms = 300; mu = 40; ks = 15000; cs = 1000; kt = 200000; ct = 50;
tstop = 5;

model = 'Quarter_Suspension_model';   % your .slx file name (without .slx)

% Make sure Simulink returns workspace outputs
set_param(model,'ReturnWorkspaceOutputs','on');

% Run the simulation and capture all To Workspace variables
simOut = sim(model,'StopTime',num2str(tstop));

% Extract the time series written by your To Workspace blocks
zs_ts   = simOut.get('zs_ts');
zu_ts   = simOut.get('zu_ts');
accs_ts = simOut.get('accs_ts');
susp_ts = simOut.get('susp_ts');

% Guard rails: error if any are missing
assert(~isempty(zs_ts),   'zs_ts not produced. Check the To Workspace block on z_s.')
assert(~isempty(zu_ts),   'zu_ts not produced. Check the To Workspace block on z_u.')
assert(~isempty(accs_ts), 'accs_ts not produced. Check the To Workspace block on acc_s.')
assert(~isempty(susp_ts), 'susp_ts not produced. Check the To Workspace block on z_s - z_u.')

% Plots
figure; plot(zs_ts.Time, zs_ts.Data); grid on; title('Body displacement z_s');
figure; plot(zu_ts.Time, zu_ts.Data); grid on; title('Wheel displacement z_u');
figure; plot(susp_ts.Time, susp_ts.Data); grid on; title('Suspension travel (z_s - z_u)');
figure; plot(accs_ts.Time, accs_ts.Data); grid on; title('Body acceleration acc_s');

% key comfort metrics
T = accs_ts.Time; a = accs_ts.Data;
rms_acc = sqrt(mean(a.^2));
peak_acc = max(abs(a));
fprintf('RMS(acc_s)= %.4g m/s^2, Peak(acc_s)= %.4g m/s^2\n', rms_acc, peak_acc);

% suspension limits check (e.g., ±0.08 m typical)
max_travel = max(abs(susp_ts.Data));
fprintf('Max suspension travel = %.4g m\n', max_travel);

% simple settling time estimate (2% band of final value ~ 0)
idx = find(abs(zs_ts.Data) < 0.02*max(abs(zs_ts.Data)),1,'last');
if ~isempty(idx), fprintf('Approx settle time z_s ~ %.3fs\n', zs_ts.Time(idx)); end
