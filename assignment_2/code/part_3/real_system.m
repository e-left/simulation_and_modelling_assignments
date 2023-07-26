function xdot = real_system(t, x, A, B)
    % real_system: function to use in an ode function to simulate system with
    % given params, matrices A 2x2 and B 2x1
    % x = [ x1 x2 ]';
    % use like this: [t, x] = ode45(@(t, x) real_system(t, x, A, B), tspan);
    xv1 = x(1);
    xv2 = x(2);
    a11 = A(1, 1);
    a12 = A(1, 2);
    a21 = A(2, 1);
    a22 = A(2, 2);
    b1 = B(1);
    b2 = B(2);
    uv = u(t);
    % make sure to return a column vector to comply with ode
    xdot = zeros(2, 1);
    xdot(1) = a11 * xv1 + a12 * xv2 + b1 * uv;
    xdot(2) = a21 * xv1 + a22 * xv2 + b2 * uv;
end

