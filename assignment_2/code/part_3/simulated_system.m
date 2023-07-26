function xdot = simulated_system(t, x, A, B, lambda, gamma)
    % simulated_system: function to use in an ode function to simulate system with
    % given params, matrices A 2x2 and B 2x1 and estimate them on-line
    % x = [ x1 x2 xhat1 xhat2 ahat11 ahat12 ahat21 ahat22 bhat1 bhat2 ]';
    % use like this: [t, x] = ode45(@(t, x) real_system(t, x, A, B, lambda), tspan);
    xv1 = x(1);
    xv2 = x(2);
    xhat1 = x(3);
    xhat2 = x(4);
    ahat11 = x(5);
    ahat12 = x(6);
    ahat21 = x(7);
    ahat22 = x(8);
    bhat1 = x(9);
    bhat2 = x(10);

    a11 = A(1, 1);
    a12 = A(1, 2);
    a21 = A(2, 1);
    a22 = A(2, 2);
    b1 = B(1);
    b2 = B(2);
    uv = u(t);

    e1 = xv1 - xhat1;
    e2 = xv2 - xhat2;
   
    x1dot = a11 * xv1 + a12 * xv2 + b1 * uv;
    x2dot = a21 * xv1 + a22 * xv2 + b2 * uv;
    xhat1dot = ahat11 * xhat1 + ahat12 * xhat2 + bhat1 * uv + lambda * e1;
    xhat2dot = ahat21 * xhat1 + ahat22 * xhat2 + bhat2 * uv + lambda * e2;

    ahat11dot = gamma * xv1 * e1;
    ahat12dot = gamma * xv2 * e1;
    ahat21dot = gamma * xv1 * e2;
    ahat22dot = gamma * xv2 * e2;

    bhat1dot = gamma * uv * e1;
    bhat2dot = gamma * uv * e2;

    xdot = [x1dot; x2dot; xhat1dot; xhat2dot; ahat11dot; ahat12dot; ...\
        ahat21dot; ahat22dot; bhat1dot; bhat2dot];
end

