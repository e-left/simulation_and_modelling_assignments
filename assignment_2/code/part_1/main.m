clear;
close all;

% set up timespan
tspan = 0:0.001:100;

% params = [a b]
params = [3 0.5];

% scenario a

% real system
[treal, xreal] = ode45(@(t, x) real_system(t, x, "a", params), tspan, 0);

% simulation
gamma = 70;
lambda = 3;
[t, x] = ode45(@(t, x) simulated_system(t, x, "a", gamma, lambda, params), tspan, [0 0 0 0 0]);

% construct useful quantities
e = xreal - x(:, 1);
ahat = lambda - x(:, 2);
bhat = x(:, 3);

figure("Name", "Predicted vs Actual");
plot(t, x(:, 1), t, xreal);
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("x", "interpreter", "latex");
legend(["$\hat{x}$" "$x$"], "Interpreter", "latex");
saveas(gcf, [pwd '/values_1_a.png']);

figure("Name", "Error")
plot(t, e);
title("Error $e = x - \hat{x}$", "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "interpreter", "latex");
saveas(gcf, [pwd '/error_1_a.png']);

figure("Name", "Value of a")
plot(t, ahat, t, 3 * ones(1, length(t)));
legend(["$\hat{a}$" "$a$"], "Interpreter", "latex");
title("a");
xlabel("time [s]", "Interpreter", "latex");
ylabel("a", "interpreter", "latex");
saveas(gcf, [pwd '/a_1_a.png']);

figure("Name", "Value of b")
plot(t, bhat, t, 0.5 * ones(1, length(t)));
title("b");
xlabel("time [s]", "Interpreter", "latex");
ylabel("b", "interpreter", "latex");
legend(["$\hat{b}$" "$b$"], "Interpreter", "latex");
saveas(gcf, [pwd '/b_1_a.png']);

% scenario b

% real system
[treal, xreal] = ode45(@(t, x) real_system(t, x, "b", params), tspan, 0);

% simulation
gamma = 70;
lambda = 3;
[t, x] = ode45(@(t, x) simulated_system(t, x, "b", gamma, lambda, params), tspan, [0 0 0 0 0]);

% construct useful quantities
e = xreal - x(:, 1);
ahat = lambda - x(:, 2);
bhat = x(:, 3);

figure
figure("Name", "Predicted vs Actual");
plot(t, x(:, 1), t, xreal);
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("x", "interpreter", "latex");
legend(["$\hat{x}$" "$x$"], "Interpreter", "latex");
saveas(gcf, [pwd '/values_1_b.png']);

figure("Name", "Error")
plot(t, e);
title("Error $e = x - \hat{x}$", "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "interpreter", "latex");
saveas(gcf, [pwd '/error_1_b.png']);

figure("Name", "Value of a")
plot(t, ahat, t, 3 * ones(1, length(t)));
legend(["$\hat{a}$" "$a$"], "Interpreter", "latex");
title("a");
xlabel("time [s]", "Interpreter", "latex");
ylabel("a", "interpreter", "latex");
saveas(gcf, [pwd '/a_1_b.png']);

figure("Name", "Value of b")
plot(t, bhat, t, 0.5 * ones(1, length(t)));
title("b");
xlabel("time [s]", "Interpreter", "latex");
ylabel("b", "interpreter", "latex");
legend(["$\hat{b}$" "$b$"], "Interpreter", "latex");
saveas(gcf, [pwd '/b_1_b.png']);