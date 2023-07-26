function xdot = real_system(t, x, params)
    % real_system: function to use in an ode function to simulate system with
    % given params
    % x = [ x ];
    % params = [a b]'
    % use like this: [t, x] = ode45(@(t, x) real_system(t, x, params), tspan);
    xv = x(1);
    a = params(1);
    b = params(2);
    uv = u(t);
    % make sure to return a column vector to comply with ode
    xdot = zeros(1, 1);
    xdot(1) =  -a * xv + b * uv ;
end

