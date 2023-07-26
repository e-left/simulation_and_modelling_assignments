function xdot = simulated_system_mixed(t, x, lambda, params, n0, f)
    % simulated_system_parallel: function to use in an ode function to simulate 
    % system with on-line parameter estimation
    % x = [x xhat ahat bhat]'
    % use like this: [t, x] = ode45(@(t, x) simulated_system_mixed(t, ...\
    % x, params, n0, f), tspan);
    xv = x(1)+ n(t, n0, f); % add noise
    xhat = x(2);
    alphaHat = x(3);
    betaHat = x(4);
    uv = u(t);

    a = params(1); 
    b = params(2);

    e = xv - xhat;

    xvdot = -a * xv + b * uv;
    xhatdot = -alphaHat * xhat + betaHat * uv - lambda * e;
    alphaHatdot = - e * xv;
    betaHatdot = e * uv;

    xdot = [xvdot; xhatdot; alphaHatdot; betaHatdot];
end

