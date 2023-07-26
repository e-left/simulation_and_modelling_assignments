close all;
clear; 

% prepare time span for all functions that need it
tspan = 0:0.00001:50;

% get measurements
[vr, vc] = v(tspan);

% get voltage measurements
u1v = u1(tspan);
u2v = u2(tspan);

% initial plot of measurements for resistor and capacitor
figure("Name", "Measurements plot for resistor and capacitor");
plot(tspan, vr, tspan, vc);
legend(["$V_R$" "$V_C$"], "Interpreter", "latex");
title("Measurements plot over time for $V_R$, $V_C$, step = 0.0001s", "Interpreter", "latex");
ylabel("Voltage [V]", "Interpreter", "latex");
xlabel("Time [s]", "Interpreter", "latex");
saveas(gcf, [pwd '/measurements_vcvr.png']);

% also plot source voltages
figure("Name", "Measurements plot for $u_1$, $u_2$");
plot(tspan, u1v, tspan, u2v);
legend(["$u_1$" "$u_2$"], "Interpreter", "latex");
title("Measurements plot over time for $u_1$, $u_2$, step = 0.0001s", "Interpreter", "latex");
ylabel("Voltage [V]", "Interpreter", "latex");
xlabel("Time [s]", "Interpreter", "latex");
saveas(gcf, [pwd '/measurements_sources.png']);

lambda = [500 250000];
L = [1 lambda(1) lambda(2)];

% estimates

% VC

estimated_VC = least_squares_estimate_Vc(vc, tspan, lambda, u1v, u2v);

% VR

% estimated_VR = least_squares_estimate_Vr(vr, tspan, lambda, u1v, u2v);

% mean value

% rcinvhat = (estimated_VC(1) + estimated_VR(1)) / 2;
% lcinvhat = (estimated_VC(2) + estimated_VR(2)) / 2;
rcinvhat = estimated_VC(1);
lcinvhat = estimated_VC(2);

% plots

% VC
theta_0_VC = [rcinvhat - lambda(1) lcinvhat - lambda(2) rcinvhat ...
    rcinvhat 0 lcinvhat]';

% construct z vector for Vc
s1 = tf([-1 0], L);
s2 = tf(-1, L);
s34 = tf([1 0], L);
s56 = tf(1, L);

z1 = lsim(s1, vc, tspan);
z2 = lsim(s2, vc, tspan);
z3 = lsim(s34, u1v, tspan);
z4 = lsim(s34, u2v, tspan);
z5 = lsim(s56, u1v, tspan);
z6 = lsim(s56, u2v, tspan);

zVC = [z1 z2 z3 z4 z5 z6]';

Vchat = theta_0_VC' * zVC;
figure("Name", "Capacitor voltage")
plot(tspan, vc, tspan, Vchat);
legend(["$V_C$", "$\\hat{V_C}$"], "Interpreter", "latex");
title(sprintf("$V_C$ and $\\hat{V_C}$, step = 0.0001s, $\\lambda_1$ = %f, $\\lambda_2$ = %f, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", lambda(1), lambda(2), rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]");
ylabel("voltage [V]");
saveas(gcf, [pwd '/vc_vchat.png']);

errorVC = vc - Vchat;
figure("Name", "Capacitor voltage error")
plot(tspan, errorVC);
title(sprintf("e = $V_C$ - $\\hat{V_C}$, $\\lambda_1$ = %f, $\\lambda_2$ = %f, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", lambda(1), lambda(2), rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "Interpreter", "latex");
saveas(gcf, [pwd '/vcerr.png']);

% VR
theta_0_VR = [rcinvhat - lambda(1) lcinvhat - lambda(2) 1 1 0 0 lcinvhat 0]';

% construct z vector for Vr
s1 = tf([-1 0], L);
s2 = tf(-1, L);
s34 = tf([1 0 0], L);
s56 = tf([1 0], L);
s78 = tf(1, L);

z1 = lsim(s1, vr, tspan);
z2 = lsim(s2, vr, tspan);
z3 = lsim(s34, u1v, tspan);
z4 = lsim(s34, u2v, tspan);
z5 = lsim(s56, u1v, tspan);
z6 = lsim(s56, u2v, tspan);
z7 = lsim(s78, u1v, tspan);
z8 = lsim(s78, u2v, tspan);

zVR = [z1 z2 z3 z4 z5 z6 z7 z8]';

Vrhat = theta_0_VR' * zVR;
figure("Name", "Resistor voltage")
plot(tspan, vr, tspan, Vrhat);
legend(["$V_R$", "$\\hat{V_R}$"], "Interpreter", "latex");
title(sprintf("$V_R$ and $\\hat{V_R}$, $\\lambda_1$ = %f, $\\lambda_2$ = %f, step = 0.0001s, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", lambda(1), lambda(2), rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]");
ylabel("voltage [V]");
saveas(gcf, [pwd '/vr_vrhat.png']);

errorVR = vr - Vrhat;
figure("Name", "Resistor voltage error")
plot(tspan, errorVR);
title(sprintf("e = $V_R$ - $\\hat{V_R}$, $\\lambda_1$ = %f, $\\lambda_2$ = %f, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", lambda(1), lambda(2), rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "Interpreter", "latex");
saveas(gcf, [pwd '/vrerr.png']);

% transfer matrix plot

% first construct transfer matrix
denom = [1 rcinvhat lcinvhat];
sa = tf([rcinvhat 0], denom);
sb = tf([rcinvhat lcinvhat], denom);
sc = tf([1 0 lcinvhat], denom);
sd = tf([1 0 0], denom);

% calculate values from transfer matrix

za = lsim(sa, u1v, tspan);
zb = lsim(sb, u2v, tspan);
zc = lsim(sc, u1v, tspan);
zd = lsim(sd, u2v, tspan);

Vchattm = za + zb;
Vrhattm = zc + zd;

% plot

figure("Name", "Capacitor voltage (tm)")
plot(tspan, vc, tspan, Vchattm);
legend(["$V_C$", "$\\hat{V_C}$"], "Interpreter", "latex");
title(sprintf("$V_C$ and $\\hat{V_C}$ using transfer matrix, step = 0.0001s, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]");
ylabel("voltage [V]");
saveas(gcf, [pwd '/vc_vchat_tm.png']);

errorVC = vc - Vchattm';
figure("Name", "Capacitor voltage error (tm)")
plot(tspan, errorVC);
title(sprintf("e = $V_C$ - $\\hat{V_C}$ using transfer matrix, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "Interpreter", "latex");
saveas(gcf, [pwd '/vcerr_tm.png']);

figure("Name", "Resistor voltage (tm)")
plot(tspan, vr, tspan, Vrhattm);
legend(["$V_R$", "$\\hat{V_R}$"], "Interpreter", "latex");
title(sprintf("$V_R$ and $\\hat{V_R}$ using transfer matrix, step = 0.0001s, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]");
ylabel("voltage [V]");
saveas(gcf, [pwd '/vr_vrhat_tm.png']);

errorVR = vr - Vrhattm';
figure("Name", "Resistor voltage error (tm)")
plot(tspan, errorVR);
title(sprintf("e = $V_R$ - $\\hat{V_R}$ using transfer matrix, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "Interpreter", "latex");
saveas(gcf, [pwd '/vrerr_tm.png']);

% noise

% pick 3 indices at random
% since analysis is run once, we can pick them constantly
% here, we pick the 1000000, 2000000 and 3000000 measurements to add to them 10
% times their value

idx1 = 1000000;
idx2 = 2000000;
idx3 = 3000000;

% add noise to the three random values
vc(idx1) = vc(idx1) * 11; % = vc(idx1) + vc(idx1) * 10;
vc(idx2) = vc(idx2) * 11;
vc(idx3) = vc(idx3) * 11;
vr(idx1) = vr(idx1) * 11;
vr(idx2) = vr(idx2) * 11;
vr(idx3) = vr(idx3) * 11;

% re perform the above analysis for the parameters

% replot resistor and capacitor voltages to visualise errors
% initial plot of measurements for resistor and capacitor
figure("Name", "Measurements plot for resistor and capacitor (with errors)");
plot(tspan, vr, tspan, vc);
legend(["$V_R$" "$V_C$"], "Interpreter", "latex");
title("Measurements plot over time for $V_R$, $V_C$ (with errors), step = 0.0001s", "Interpreter", "latex");
ylabel("Voltage [V]", "Interpreter", "latex");
xlabel("Time [s]", "Interpreter", "latex");
saveas(gcf, [pwd '/measurements_vcvr_err.png']);

% estimates (with errors)

% VC

estimated_VC = least_squares_estimate_Vc(vc, tspan, lambda, u1v, u2v);

% VR

% estimated_VR = least_squares_estimate_Vr(vr, tspan, lambda, u1v, u2v);

% mean value

% rcinvhat = (estimated_VC(1) + estimated_VR(1)) / 2;
% lcinvhat = (estimated_VC(2) + estimated_VR(2)) / 2;
rcinvhat = estimated_VC(1);
lcinvhat = estimated_VC(2);

% plots

% VC
theta_0_VC = [rcinvhat - lambda(1) lcinvhat - lambda(2) rcinvhat ...
    rcinvhat 0 lcinvhat]';

% construct z vector for Vc
s1 = tf([-1 0], L);
s2 = tf(-1, L);
s34 = tf([1 0], L);
s56 = tf(1, L);

z1 = lsim(s1, vc, tspan);
z2 = lsim(s2, vc, tspan);
z3 = lsim(s34, u1v, tspan);
z4 = lsim(s34, u2v, tspan);
z5 = lsim(s56, u1v, tspan);
z6 = lsim(s56, u2v, tspan);

zVC = [z1 z2 z3 z4 z5 z6]';

Vchat = theta_0_VC' * zVC;
figure("Name", "Capacitor voltage (with errors)")
plot(tspan, vc, tspan, Vchat);
legend(["$V_C$", "$\\hat{V_C}$"], "Interpreter", "latex");
title(sprintf("$V_C$ and $\\hat{V_C}$ (with errors), step = 0.0001s, $\\lambda_1$ = %f, $\\lambda_2$ = %f, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", lambda(1), lambda(2), rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]");
ylabel("voltage [V]");
saveas(gcf, [pwd '/vc_vchat_err.png']);

errorVC = vc - Vchat;
figure("Name", "Capacitor voltage error (with errors)")
plot(tspan, errorVC);
title(sprintf("e = $V_C$ - $\\hat{V_C}$ (with errors), $\\lambda_1$ = %f, $\\lambda_2$ = %f, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", lambda(1), lambda(2), rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "Interpreter", "latex");
saveas(gcf, [pwd '/vcerr_err.png']);

% VR
theta_0_VR = [rcinvhat - lambda(1) lcinvhat - lambda(2) 1 1 0 0 lcinvhat 0]';

% construct z vector for Vr
s1 = tf([-1 0], L);
s2 = tf(-1, L);
s34 = tf([1 0 0], L);
s56 = tf([1 0], L);
s78 = tf(1, L);

z1 = lsim(s1, vr, tspan);
z2 = lsim(s2, vr, tspan);
z3 = lsim(s34, u1v, tspan);
z4 = lsim(s34, u2v, tspan);
z5 = lsim(s56, u1v, tspan);
z6 = lsim(s56, u2v, tspan);
z7 = lsim(s78, u1v, tspan);
z8 = lsim(s78, u2v, tspan);

zVR = [z1 z2 z3 z4 z5 z6 z7 z8]';

Vrhat = theta_0_VR' * zVR;
figure("Name", "Resistor voltage (with errors)")
plot(tspan, vr, tspan, Vrhat);
legend(["$V_R$", "$\\hat{V_R}$"], "Interpreter", "latex");
title(sprintf("$V_R$ and $\\hat{V_R}$ (with errors), $\\lambda_1$ = %f, $\\lambda_2$ = %f, step = 0.0001s, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", lambda(1), lambda(2), rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]");
ylabel("voltage [V]");
saveas(gcf, [pwd '/vr_vrhat_err.png']);

errorVR = vr - Vrhat;
figure("Name", "Resistor voltage error (with errors)")
plot(tspan, errorVR);
title(sprintf("e = $V_R$ - $\\hat{V_R}$ (with errors), $\\lambda_1$ = %f, $\\lambda_2$ = %f, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", lambda(1), lambda(2), rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "Interpreter", "latex");
saveas(gcf, [pwd '/vrerr_err.png']);

% transfer matrix plot

% first construct transfer matrix
denom = [1 rcinvhat lcinvhat];
sa = tf([rcinvhat 0], denom);
sb = tf([rcinvhat lcinvhat], denom);
sc = tf([1 0 lcinvhat], denom);
sd = tf([1 0 0], denom);

% calculate values from transfer matrix

za = lsim(sa, u1v, tspan);
zb = lsim(sb, u2v, tspan);
zc = lsim(sc, u1v, tspan);
zd = lsim(sd, u2v, tspan);

Vchattm = za + zb;
Vrhattm = zc + zd;

% plot

figure("Name", "Capacitor voltage (tm) (errors)")
plot(tspan, vc, tspan, Vchattm);
legend(["$V_C$", "$\\hat{V_C}$"], "Interpreter", "latex");
title(sprintf("$V_C$ and $\\hat{V_C}$ using transfer matrix (with errors), step = 0.0001s, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]");
ylabel("voltage [V]");
saveas(gcf, [pwd '/vc_vchat_tm_err.png']);

errorVC = vc - Vchattm';
figure("Name", "Capacitor voltage error (tm) (errors)")
plot(tspan, errorVC);
title(sprintf("e = $V_C$ - $\\hat{V_C}$ using transfer matrix (with errors), $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "Interpreter", "latex");
saveas(gcf, [pwd '/vcerr_tm_err.png']);

figure("Name", "Resistor voltage (tm)")
plot(tspan, vr, tspan, Vrhattm);
legend(["$V_R$", "$\\hat{V_R}$"], "Interpreter", "latex");
title(sprintf("$V_R$ and $\\hat{V_R}$ using transfer matrix (with errors), step = 0.0001s, $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]");
ylabel("voltage [V]");
saveas(gcf, [pwd '/vr_vrhat_tm_err.png']);

errorVR = vr - Vrhattm';
figure("Name", "Resistor voltage error (tm) (errors)")
plot(tspan, errorVR);
title(sprintf("e = $V_R$ - $\\hat{V_R}$ using transfer matrix (with errors), $\\hat{\\frac{1}{RC}}$ = %f, $\\hat{\\frac{1}{RC}}$ = %f", rcinvhat, lcinvhat), "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "Interpreter", "latex");
saveas(gcf, [pwd '/vrerr_tm_err.png']);