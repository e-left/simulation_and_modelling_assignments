% clear all
clear;
close all;
clc;

% part A: check if system is linear
t = 0:0.001:100;

ua = @(t) 2 * cos(t);
ub = @(t) 6 * cos(2 * t);
uc = @(t) 8 * cos(3 * t);
ud = @(t) -6 * cos(4 * t);
ue = @(t) -10 * cos(5 * t);
uf = @(t) 12 * cos(6 * t);

u = @(t) 2 * cos(t) + 6 * cos(2 * t) + 8 * cos(3 * t) ...\\
    + (-6) * cos(4 * t) + (-10) * cos(5 * t) + 12 * cos(6 * t);

[ya, ~] = sys(t, ua);
[yb, ~] = sys(t, ub);
[yc, ~] = sys(t, uc);
[yd, ~] = sys(t, ud);
[ye, ~] = sys(t, ue);
[yf, ~] = sys(t, uf);
[y, ~] = sys(t, u);

constructed = ya + yb + yc + yd + ye + yf;
error = constructed - y;

figure("Name", "Linearity error")
plot(t, error, "LineWidth", 2);
title("Linearity error");
xlabel("Time");
ylabel("Error");
xlim([0, 100]);
saveas(gcf, [pwd '/linearity_error.png']);

% part B: determine parameters of system

% offline: using least squares estimator
ut = u(t);
yt = y;
p = 5;

figure("Name", "Modelling error");
mse_metrics = zeros(21, 1);
params = zeros(21, 3);
subplot_idx = 1;
for n = 2:7
    for m = 1:n-1   
        % least squares estimation of parameters
        [z,lambda] = sys_parametrized(n, m, p, t, ut, yt);

        theta_l = (y'*z)/(z' * z);
        theta_estimated = zeros(1, n + m + 1);
        
        for k = 1:n + m + 1
            if k <= n 
                theta_estimated(k) = theta_l(k) + lambda(k+1);
            else
                theta_estimated(k) = theta_l(k);
            end
        end

        % simulate based on parameters
        s_Y = ones(1, n); 
        s_U = zeros(1, m + 1);

        for j=1:n + m + 1
            if j <= n
                s_Y(j + 1) = theta_estimated(j); 
            else
                s_U(j - n) = theta_estimated(j); 
            end
        end

        s_tf = tf(s_U, s_Y);
        y_estimated = lsim(s_tf, ut, t);   

        % derive modelling error
        modelling_error = yt - y_estimated;

        % plot error
        subplot(4, 6, subplot_idx);
        mse_metrics(subplot_idx) = sum(modelling_error .* modelling_error) / length(modelling_error);
        params(subplot_idx, :) = [n, m, p];
        subplot_idx = subplot_idx + 1;
        sys_params_name = sprintf("Modelling Error n = %d, m = %d, p = %d", n, m, p);
        plot(t, modelling_error, "LineWidth", 2, "Color", "red");
        title(sys_params_name);
        xlabel("Time");
        xlim([0 100]); 
        ylabel("Error");
    end
end
saveas(gcf, [pwd '/modelling_errors.png']);

% print all parameter and MSEs

for k = 1:length(params)
    params_k = params(k, :);
    nk = params_k(1);
    mk = params_k(2);
    pk = params_k(3);
    mse = mse_metrics(k);
    fprintf("Offline estimator: n = %d, m = %d, p = %d, MSE = %f\n", nk, mk, pk, mse);
end

[min_error_offline, min_error_idx] = min(mse_metrics);
offline_optimal_params = params(min_error_idx, :);
fprintf("Optimal offline estimator: n = %d, m = %d, p = %d, MSE = %f\n", offline_optimal_params(1), offline_optimal_params(2), offline_optimal_params(3), min_error_offline);

n = offline_optimal_params(1);
m = offline_optimal_params(2);
p = offline_optimal_params(3);

[z,lambda] = sys_parametrized(n, m, p, t, ut, yt);

theta_l = (y'*z)/(z' * z);
theta_estimated = zeros(1, n + m + 1);

for k = 1:n + m + 1
    if k <= n 
        theta_estimated(k) = theta_l(k) + lambda(k+1);
    else
        theta_estimated(k) = theta_l(k);
    end
end

s_Y = ones(1, n); 
s_U = zeros(1, m + 1);

for j=1:n + m + 1
    if j <= n
        s_Y(j + 1) = theta_estimated(j); 
    else
        s_U(j - n) = theta_estimated(j); 
    end
end

s_tf = tf(s_U,s_Y);
y_estimated = lsim(s_tf, ut, t);   

% derive modelling error
modelling_error = yt - y_estimated;

% plot error
sys_params_name = sprintf("Modelling Error n = %d, m = %d, p = %d", n, m, p);
figure("Name", sys_params_name);
plot(t, modelling_error, "LineWidth", 2, "Color", "red");
title(sys_params_name);
xlabel("Time");
ylabel("Error");
saveas(gcf, [pwd '/optimal_offline_error.png']);

disp("Theta estimated offline for optimal estimator:")
disp(theta_estimated);

% online estimation
figure("Name", "Modelling error");
mse_metrics = zeros(21, 1);
params = zeros(21, 2);
subplot_idx = 1;
for n = 2:7
    for m = 1:n-1   
        % choose initial theta of ones
        theta = zeros(n + m + 1, 1);
        % initial matrix
        P = eye(n + m + 1);
        % hold output of system somewhere
        sys_output_train = zeros(length(t), 1);
        % loop over time data
        for t_idx = 1:length(t)
            % construct phi vector
            phi = zeros(n + m + 1, 1);
            for k = 1:n
                value = 0;
                if t_idx - k > 0
                    value = yt(t_idx - k);
                end
                phi(k) = value;
            end
            for k = 1:(m + 1)
                value = 0;
                if t_idx - (k - 1) > 0
                    value = ut(t_idx - (k - 1));
                end
                phi(n + k) = value;
            end

            % calculate output
            sys_output_train(t_idx) = theta.' * phi;

            % change theta vector and P matrix
            theta = theta + (P * (yt(t_idx) - sys_output_train(t_idx)) * phi) * 0.001;
            P = P + (- P * (phi * phi.') * P) * 0.001;
        end

        % run once more to produce modelling error
        predict_y = zeros(length(t), 1);
        for t_idx = 1:length(t)
            % construct phi vector
            phi = zeros(n + m + 1, 1);
            for k = 1:n
                value = 0;
                if t_idx - k > 0
                    value = yt(t_idx - k);
                end
                phi(k) = value;
            end
            for k = 1:(m + 1)
                value = 0;
                if t_idx - (k - 1) > 0
                    value = ut(t_idx - (k - 1));
                end
                phi(n + k) = value;
            end

            % calculate output
            predict_y(t_idx) = theta.' * phi;
        end

        modelling_error = yt - predict_y;

        subplot(4, 6, subplot_idx);
        mse_modelling_error = modelling_error(round(0.75 * length(modelling_error)):end);
        mse_metrics(subplot_idx) = sum(mse_modelling_error .* mse_modelling_error) / length(mse_modelling_error);
        params(subplot_idx, :) = [n, m];
        subplot_idx = subplot_idx + 1;
        sys_params_name = sprintf("Modelling Error n = %d, m = %d", n, m);
        plot(t, modelling_error, "LineWidth", 2, "Color", "red");
        title(sys_params_name);
        xlabel("Time");
        xlim([0, 100]);
        ylabel("Error");
    end
end
saveas(gcf, [pwd '/modelling_errors_online.png']);

% print all parameter and MSEs

for k = 1:length(params)
    params_k = params(k, :);
    nk = params_k(1);
    mk = params_k(2);
    mse = mse_metrics(k);
    fprintf("Online estimator: n = %d, m = %d, MSE = %f\n", nk, mk, mse);
end

[min_error_online, min_error_idx] = min(mse_metrics);
online_optimal_params = params(min_error_idx, :);
fprintf("Optimal online estimator: n = %d, m = %d, MSE = %f\n", online_optimal_params(1), online_optimal_params(2), min_error_online);

n = online_optimal_params(1);
m = online_optimal_params(2);

% determine optimal theta
theta = zeros(n + m + 1, 1);
% initial matrix
P = eye(n + m + 1);
sys_output_train = zeros(length(t), 1);
for t_idx = 1:length(t)
    % construct phi vector
    phi = zeros(n + m + 1, 1);
    for k = 1:n
        value = 0;
        if t_idx - k > 0
            value = yt(t_idx - k);
        end
        phi(k) = value;
    end
    for k = 1:(m + 1)
        value = 0;
        if t_idx - (k - 1) > 0
            value = ut(t_idx - (k - 1));
        end
        phi(n + k) = value;
    end

    % calculate output
    sys_output_train(t_idx) = theta.' * phi;

    % change theta vector and P matrix
    theta = theta + (P * (yt(t_idx) - sys_output_train(t_idx)) * phi) * 0.001;
    P = P + (- P * (phi * phi.') * P) * 0.001;
end

% run once more to produce modelling error
predict_y = zeros(length(t), 1);
for t_idx = 1:length(t)
    % construct phi vector
    phi = zeros(n + m + 1, 1);
    for k = 1:n
        value = 0;
        if t_idx - k > 0
            value = yt(t_idx - k);
        end
        phi(k) = value;
    end
    for k = 1:(m + 1)
        value = 0;
        if t_idx - (k - 1) > 0
            value = ut(t_idx - (k - 1));
        end
        phi(n + k) = value;
    end

    % calculate output
    predict_y(t_idx) = theta.' * phi;
end

modelling_error = yt - predict_y;

% plot error
sys_params_name = sprintf("Modelling Error n = %d, m = %d", n, m);
figure("Name", sys_params_name);
plot(t, modelling_error, "LineWidth", 2, "Color", "red");
title(sys_params_name);
xlabel("Time");
ylabel("Error");
saveas(gcf, [pwd '/optimal_online_error.png']);

disp("Theta estimated online for optimal estimator:")
disp(theta);