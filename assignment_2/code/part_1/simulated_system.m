function xdot = simulated_system(t, x, scenario, gamma, lambda, params)
    % simulated_system: function to use in an ode function to simulate 
    % system with on-line parameter estimation
    % x = [x thetaHat1 thetaHat2 phi1 phi2]'
    % scenario is either "a" or "b"
    % gamma is a positive constant, lambda is the pole of the filter
    % use like this: [t, x] = ode45(@(t, x) simulated_system(t, x, "a", ...
    % gamma, lambda, params), tspan);
    xv = x(1);
    thetaHat1 = x(2);
    thetaHat2 = x(3);
    phi1 = x(4);
    phi2 = x(5);
    uv = 0;
    if scenario == "a"
        uv = ua(t);
    elseif scenario == "b"
        uv = ub(t);
    end

    a = params(1); 
    b = params(2);

    xhat = thetaHat1 * phi1 + thetaHat2 * phi2; % theta' * phi
    e = xv - xhat; 

    xvdot = -a * xv + b * uv;
    thetaHat1dot = gamma * e * phi1;
    thetaHat2dot = gamma * e * phi2;
    phi1dot = -lambda * phi1 + xv;
    phi2dot = -lambda * phi2 + uv;

    xdot = [xvdot; thetaHat1dot; thetaHat2dot; phi1dot; phi2dot];
end

