function params = least_squares_estimate(lambda)
    % lambda = [lambda1 lambda2]
    % params = [m b k]
    % returns least squares estimate of parameters

    % filter parameters
    lambda1 = lambda(1);
    lambda2 = lambda(2);
    % set up timespan
    tspan = 0:0.1:10;
    % only to obtain real displacement measurements
    real_params = [10 0.5 2.5];
    y0 = [0; 0];
    [~, y_measured] = ode45(@(t,y) spring_system(t, y, real_params), tspan, y0);
    % obtain force measurements
    u_measured = u(tspan);

    % construct z vectors
    L = [1 lambda1 lambda2];
    s1 = tf([-1 0], L);
    s2 = tf(-1, L);
    s3 = tf(1, L);

    z1 = lsim(s1, y_measured(:, 1), tspan);
    z2 = lsim(s2, y_measured(:, 1), tspan);
    z3 = lsim(s3, u_measured, tspan);

    z = [z1 z2 z3]';

    %calculate the tables A and B (A * theta_0 = B)
    A = zeros(3, 3);
    B = zeros(3, 1);
    
    N = length(tspan);

    for i=1:N
        A = A + (1 / N) * (z(:, i) * z(:, i)');
        B = B + (1 / N) * (z(:, i) * y_measured(i, 1));
    end

    % performance
    theta_l = linsolve(A, B);

    m = 1 / theta_l(3);
    b = m * (theta_l(1) + lambda1);
    k = m * (theta_l(2) + lambda2);

    params = [m b k];
end