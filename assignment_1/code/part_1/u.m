function force = u(t)
    % external force passed to spring
    % works with both scalar values and vectors
    force = 15 * sin(3 * t) + 8;
end

