clear;
close all;

% set up timespan
tspan = 0:0.1:100;

% params A, B
A = [-0.25 3; -5 0];
B = [0.5; 1.5];

% real system
[treal, xreal] = ode45(@(t, x) real_system(t, x, A, B), tspan, [0 0]);

% simulation
lambda = 1;
gamma = 50;
[t, x] = ode45(@(t, x) simulated_system(t, x, A, B, lambda, gamma), tspan, [0 0 0 0 0 0 0 0 0 0]);

% construct useful quantities
xreal1 = xreal(:, 1);
xreal2 = xreal(:, 2);
xhat1 = x(:, 3);
xhat2 = x(:, 4);
e1 = xreal1 - xhat1;
e2 = xreal2 - xhat2;
ahat11 = x(:, 5);
ahat12 = x(:, 6);
ahat21 = x(:, 7);
ahat22 = x(:, 8);
bhat1 = x(:, 9);
bhat2 = x(:, 10);

% plots

figure("Name", "Predicted vs Actual for x1");
plot(t, xhat1, treal, xreal1);
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("$x_1$", "interpreter", "latex");
legend(["$\hat{x}_1$" "$x_1$"], "Interpreter", "latex");
saveas(gcf, [pwd '/values_3_1.png']);

figure("Name", "Predicted vs Actual for x2");
plot(t, xhat2, treal, xreal2);
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("$x_2$", "interpreter", "latex");
legend(["$\hat{x}_2$" "$x_2$"], "Interpreter", "latex");
saveas(gcf, [pwd '/values_3_2.png']);

figure("Name", "Error for x1")
plot(t, e1);
title("Error")
xlabel("time [s]", "Interpreter", "latex");
ylabel("$e_1$", "interpreter", "latex");
saveas(gcf, [pwd '/error_3_1.png']);

figure("Name", "Error for x2")
plot(t, e2);
title("Error")
xlabel("time [s]", "Interpreter", "latex");
ylabel("$e_2$", "interpreter", "latex");
saveas(gcf, [pwd '/error_3_2.png']);

figure("Name", "Predicted vs Actual for a11");
plot(t, ahat11, t, - 0.25 * ones(1, length(t)));
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("$a_{11}$", "interpreter", "latex");
legend(["$\hat{a}_{11}$" "$a_{11}$"], "Interpreter", "latex");
saveas(gcf, [pwd '/a11_3.png']);

figure("Name", "Predicted vs Actual for a12");
plot(t, ahat12, t, 3 * ones(1, length(t)));
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("$a_{12}$", "interpreter", "latex");
legend(["$\hat{a}_{12}$" "$a_{12}$"], "Interpreter", "latex");
saveas(gcf, [pwd '/a12_3.png']);

figure("Name", "Predicted vs Actual for a21");
plot(t, ahat21, t, - 5 * ones(1, length(t)));
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("$a_{21}$", "interpreter", "latex");
legend(["$\hat{a}_{21}$" "$a_{21}$"], "Interpreter", "latex");
saveas(gcf, [pwd '/a21_3.png']);

figure("Name", "Predicted vs Actual for a22");
plot(t, ahat22, t, zeros(1, length(t)));
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("$a_{22}$", "interpreter", "latex");
legend(["$\hat{a}_{22}$" "$a_{22}$"], "Interpreter", "latex");
saveas(gcf, [pwd '/a22_3.png']);

figure("Name", "Predicted vs Actual for b1");
plot(t, bhat1, t, 0.5 * ones(1, length(t)));
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("$b_1$", "interpreter", "latex");
legend(["$\hat{b}_1$" "$b_1$"], "Interpreter", "latex");
saveas(gcf, [pwd '/b1_3.png']);

figure("Name", "Predicted vs Actual for b2");
plot(t, bhat2, t, 1.5 * ones(1, length(t)));
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("$b_2$", "interpreter", "latex");
legend(["$\hat{b}_2$" "$b_2$"], "Interpreter", "latex");
saveas(gcf, [pwd '/b2_3.png']);
