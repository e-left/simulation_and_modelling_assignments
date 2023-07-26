function ydot = spring_system(t, y, params)
    % system function
    % use like this: [t,y] = ode45(@(t,y) system(t, y, params), tspan, y0);
    y1 = y(1); % position
    y2 = y(2); % velocity
    % params = [m b k];
    m = params(1);
    b = params(2);
    k = params(3);
    ydot1 = y2;
    ydot2 = -(b / m) * y2 - (k / m) * y1 + (1 / m) * u(t);
    ydot = [ydot1; ydot2];
end

