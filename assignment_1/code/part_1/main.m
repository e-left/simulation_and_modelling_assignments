clear;
clc;
close all;

% filter parameters
% change to observe different predictions
lambda = [1 1]; 

% set up initial conditions and time span per assignment instructions
y0 = [0; 0];
tspan = 0:0.1:10;

% solve system (real params)
params = [10 0.5 2.5];
[~,y] = ode45(@(t,y) spring_system(t, y, params), tspan, y0);

% estimate parameters
estimated_params = least_squares_estimate(lambda);
[t, yhat] = ode45(@(t,y) spring_system(t, y, estimated_params), tspan, y0);

% plot results

% predicted value vs actual value
figure("Name", "Position actual vs predicted")
plot(t, y(:, 1), t, yhat(:, 1));
title(sprintf("Position graph [$m$], $\\hat{m}=%f$, $\\hat{b}=%f$, $\\hat{k}=%f$", ...
    estimated_params(1), estimated_params(2), estimated_params(3)), "Interpreter", "latex");
legend(["actual", "estimated"], "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("displacement [m]", "Interpreter", "latex");
saveas(gcf, [pwd '/position_graph.png']);

% error
figure("Name", "Error")
plot(t, y(:, 1) - yhat(:, 1));
title(sprintf("Error graph $e = y - \\hat{y}$, $\\hat{m}=%f$, $\\hat{b}=%f$, $\\hat{k}=%f$", ...
    estimated_params(1), estimated_params(2), estimated_params(3)), "Interpreter", "latex");
legend("error", "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "Interpreter", "latex");
saveas(gcf, [pwd '/error_graph.png']);


