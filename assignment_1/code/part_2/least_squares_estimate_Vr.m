function params = least_squares_estimate_Vr(measurements, tspan, lambda, u1v, u2v)
    % lambda = [lambda1 lambda2]
    % params = [1 / (R*C) 1 / (L*C)]
    % returns least squares estimate of parameters

    % filter parameters
    lambda1 = lambda(1);
    lambda2 = lambda(2);

    % construct z vector
    L = [1 lambda1 lambda2];
    s1 = tf([-1 0], L);
    s2 = tf(-1, L);
    s34 = tf([1 0 0], L);
    s56 = tf([1 0], L);
    s78 = tf(1, L);

    z1 = lsim(s1, measurements, tspan);
    z2 = lsim(s2, measurements, tspan);
    z3 = lsim(s34, u1v, tspan);
    z4 = lsim(s34, u2v, tspan);
    z5 = lsim(s56, u1v, tspan);
    z6 = lsim(s56, u2v, tspan);
    z7 = lsim(s78, u1v, tspan);
    z8 = lsim(s78, u2v, tspan);

    z = [z1 z2 z3 z4 z5 z6 z7 z8]';

    % calculate the tables A and B (A * theta_0 = B)
    A = zeros(8, 8);
    B = zeros(8, 1);
    
    N = length(tspan);

    for i=1:N
        A = A + (1 / N) * (z(:, i) * z(:, i)');
        B = B + (1 / N) * (z(:, i) * measurements(i));
    end

    % performance
    theta_l = linsolve(A, B);

    % param1 = 1 / (R * C)
    % param2 = 1 / (L * C)
    rcparts = [theta_l(1) + lambda1];
    lcparts = [theta_l(2) + lambda2 theta_l(6) theta_l(7)];

    param1 = mean(rcparts);
    param2 = mean(lcparts);

    params = [param1 param2];
end