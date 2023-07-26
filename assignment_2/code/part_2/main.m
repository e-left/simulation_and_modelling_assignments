clear;
close all;

% set up timespan
tspan = 0:0.001:100;

% params = [a b]
params = [3 0.5];

% parallel

% real system
[treal, xreal] = ode45(@(t, x) real_system(t, x, params), tspan, 0);

% simulation
n0 = 0.5;
f = 40;
[t, x] = ode45(@(t, x) simulated_system_parallel(t, x, params, n0, f), tspan, [0 0 0 0]);

% construct useful quantities
e = xreal - x(:, 2);
ahat = x(:, 3);
bhat = x(:, 4);

figure("Name", "Predicted vs Actual");
plot(t, x(:, 1), t, xreal);
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("x", "interpreter", "latex");
legend(["$\hat{x}$" "$x$"], "Interpreter", "latex");
saveas(gcf, [pwd '/values_2_p.png']);

figure("Name", "Error")
plot(t, e);
title("Error $e = x - \hat{x}$", "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "interpreter", "latex");
saveas(gcf, [pwd '/error_2_p.png']);

figure("Name", "Value of a")
plot(t, ahat, t, 3 * ones(1, length(t)));
legend(["$\hat{a}$" "$a$"], "Interpreter", "latex");
title("a");
xlabel("time [s]", "Interpreter", "latex");
ylabel("a", "interpreter", "latex");
saveas(gcf, [pwd '/a_2_p.png']);

figure("Name", "Value of b")
plot(t, bhat, t, 0.5 * ones(1, length(t)));
title("b");
xlabel("time [s]", "Interpreter", "latex");
ylabel("b", "interpreter", "latex");
legend(["$\hat{b}$" "$b$"], "Interpreter", "latex");
saveas(gcf, [pwd '/b_2_p.png']);

% mixed

% real system
[treal, xreal] = ode45(@(t, x) real_system(t, x, params), tspan, 0);

% simulation
n0 = 0.5;
f = 40;
lambda = 1;
[t, x] = ode45(@(t, x) simulated_system_mixed(t, x, lambda, params, n0, f), tspan, [0 0 0 0]);

% construct useful quantities
e = xreal - x(:, 2);
ahat = x(:, 3);
bhat = x(:, 4);

figure("Name", "Predicted vs Actual");
plot(t, x(:, 1), t, xreal);
title("Predicted vs Actual");
xlabel("time [s]", "Interpreter", "latex");
ylabel("x", "interpreter", "latex");
legend(["$\hat{x}$" "$x$"], "Interpreter", "latex");
saveas(gcf, [pwd '/values_2_m.png']);

figure("Name", "Error")
plot(t, e);
title("Error $e = x - \hat{x}$", "Interpreter", "latex");
xlabel("time [s]", "Interpreter", "latex");
ylabel("error", "interpreter", "latex");
saveas(gcf, [pwd '/error_2_m.png']);

figure("Name", "Value of a")
plot(t, ahat, t, 3 * ones(1, length(t)));
legend(["$\hat{a}$" "$a$"], "Interpreter", "latex");
title("a");
xlabel("time [s]", "Interpreter", "latex");
ylabel("a", "interpreter", "latex");
saveas(gcf, [pwd '/a_2_m.png']);

figure("Name", "Value of b")
plot(t, bhat, t, 0.5 * ones(1, length(t)));
title("b");
xlabel("time [s]", "Interpreter", "latex");
ylabel("b", "interpreter", "latex");
legend(["$\hat{b}$" "$b$"], "Interpreter", "latex");
saveas(gcf, [pwd '/b_2_m.png']);

% do the above, only vary n0 and f
n0 = [0.5 1 2]
f = [20 40 60]
% no scenario crossing
for n0=[1 1.5]

    % parallel

    % real system
    [treal, xreal] = ode45(@(t, x) real_system(t, x, params), tspan, 0);

    % simulation
    f = 40;
    [t, x] = ode45(@(t, x) simulated_system_parallel(t, x, params, n0, f), tspan, [0 0 0 0]);

    % construct useful quantities
    e = xreal - x(:, 1);
    ahat = x(:, 3);
    bhat = x(:, 4);

    figure("Name", "Predicted vs Actual");
    plot(t, x(:, 1), t, xreal);
    title("Predicted vs Actual");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("x", "interpreter", "latex");
    legend(["$\hat{x}$" "$x$"], "Interpreter", "latex");
    saveas(gcf, [pwd sprintf('/values_2_p_n0_%f_f_40.png', n0)]);

    figure("Name", "Error")
    plot(t, e);
    title("Error $e = x - \hat{x}$", "Interpreter", "latex");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("error", "interpreter", "latex");
    saveas(gcf, [pwd sprintf('/error_2_p_n0_%f_f_40.png', n0)]);

    figure("Name", "Value of a")
    plot(t, ahat, t, 3 * ones(1, length(t)));
    legend(["$\hat{a}$" "$a$"], "Interpreter", "latex");
    title("a");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("a", "interpreter", "latex");
    saveas(gcf, [pwd sprintf('/a_2_p_n0_%f_f_40.png', n0)]);

    figure("Name", "Value of b")
    plot(t, bhat, t, 0.5 * ones(1, length(t)));
    title("b");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("b", "interpreter", "latex");
    legend(["$\hat{b}$" "$b$"], "Interpreter", "latex");
    saveas(gcf, [pwd sprintf('/b_2_p_n0_%f_f_40.png', n0)]);

    % mixed

    % real system
    [treal, xreal] = ode45(@(t, x) real_system(t, x, params), tspan, 0);

    % simulation
    f = 40;
    lambda = 1;
    [t, x] = ode45(@(t, x) simulated_system_mixed(t, x, lambda, params, n0, f), tspan, [0 0 0 0]);

    % construct useful quantities
    e = xreal - x(:, 1);
    ahat = x(:, 3);
    bhat = x(:, 4);

    figure("Name", "Predicted vs Actual");
    plot(t, x(:, 1), t, xreal);
    title("Predicted vs Actual");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("x", "interpreter", "latex");
    legend(["$\hat{x}$" "$x$"], "Interpreter", "latex");
    saveas(gcf, [pwd sprintf('/values_2_m_n0_%f_f_40.png', n0)]);

    figure("Name", "Error")
    plot(t, e);
    title("Error $e = x - \hat{x}$", "Interpreter", "latex");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("error", "interpreter", "latex");
    saveas(gcf, [pwd sprintf('/error_2_m_n0_%f_f_40.png', n0)]);

    figure("Name", "Value of a")
    plot(t, ahat, t, 3 * ones(1, length(t)));
    legend(["$\hat{a}$" "$a$"], "Interpreter", "latex");
    title("a");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("a", "interpreter", "latex");
    saveas(gcf, [pwd sprintf('/a_2_m_n0_%f_f_40.png', n0)]);

    figure("Name", "Value of b")
    plot(t, bhat, t, 0.5 * ones(1, length(t)));
    title("b");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("b", "interpreter", "latex");
    legend(["$\hat{b}$" "$b$"], "Interpreter", "latex");
    saveas(gcf, [pwd sprintf('/b_2_m_n0_%f_f_40.png', n0)]);

end

for f=[20 60]

     % parallel

    % real system
    [treal, xreal] = ode45(@(t, x) real_system(t, x, params), tspan, 0);

    % simulation
    n0 = 0.5;
    [t, x] = ode45(@(t, x) simulated_system_parallel(t, x, params, n0, f), tspan, [0 0 0 0]);

    % construct useful quantities
    e = xreal - x(:, 2);
    ahat = x(:, 3);
    bhat = x(:, 4);

    figure("Name", "Predicted vs Actual");
    plot(t, x(:, 1), t, xreal);
    title("Predicted vs Actual");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("x", "interpreter", "latex");
    legend(["$\hat{x}$" "$x$"], "Interpreter", "latex");
    saveas(gcf, [pwd sprintf('/values_2_p_n0_0.5_f_%f.png', f)]);

    figure("Name", "Error")
    plot(t, e);
    title("Error $e = x - \hat{x}$", "Interpreter", "latex");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("error", "interpreter", "latex");
    saveas(gcf, [pwd sprintf('/error_2_p_n0_0.5_f_%f.png', f)]);

    figure("Name", "Value of a")
    plot(t, ahat, t, 3 * ones(1, length(t)));
    legend(["$\hat{a}$" "$a$"], "Interpreter", "latex");
    title("a");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("a", "interpreter", "latex");
    saveas(gcf, [pwd sprintf('/a_2_p_n0_0.5_f_%f.png', f)]);

    figure("Name", "Value of b")
    plot(t, bhat, t, 0.5 * ones(1, length(t)));
    title("b");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("b", "interpreter", "latex");
    legend(["$\hat{b}$" "$b$"], "Interpreter", "latex");
    saveas(gcf, [pwd sprintf('/b_2_p_n0_0.5_f_%f.png', f)]);

    % mixed

    % real system
    [treal, xreal] = ode45(@(t, x) real_system(t, x, params), tspan, 0);

    % simulation
    n0 = 0.5;
    lambda = 1;
    [t, x] = ode45(@(t, x) simulated_system_mixed(t, x, lambda, params, n0, f), tspan, [0 0 0 0]);

    % construct useful quantities
    e = xreal - x(:, 2);
    ahat = x(:, 3);
    bhat = x(:, 4);

    figure("Name", "Predicted vs Actual");
    plot(t, x(:, 1), t, xreal);
    title("Predicted vs Actual");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("x", "interpreter", "latex");
    legend(["$\hat{x}$" "$x$"], "Interpreter", "latex");
    saveas(gcf, [pwd sprintf('/values_2_m_n0_0.5_f_%f.png', f)]);

    figure("Name", "Error")
    plot(t, e);
    title("Error $e = x - \hat{x}$", "Interpreter", "latex");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("error", "interpreter", "latex");
    saveas(gcf, [pwd sprintf('/error_2_m_n0_0.5_f_%f.png', f)]);

    figure("Name", "Value of a")
    plot(t, ahat, t, 3 * ones(1, length(t)));
    legend(["$\hat{a}$" "$a$"], "Interpreter", "latex");
    title("a");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("a", "interpreter", "latex");
    saveas(gcf, [pwd sprintf('/a_2_m_n0_0.5_f_%f.png', f)]);

    figure("Name", "Value of b")
    plot(t, bhat, t, 0.5 * ones(1, length(t)));
    title("b");
    xlabel("time [s]", "Interpreter", "latex");
    ylabel("b", "interpreter", "latex");
    legend(["$\hat{b}$" "$b$"], "Interpreter", "latex");
    saveas(gcf, [pwd sprintf('/b_2_m_n0_0.5_f_%f.png', f)]);

end
