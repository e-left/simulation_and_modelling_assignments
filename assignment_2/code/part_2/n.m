function out = n(t, n0, f)
    % n: returns values of noise n given an array or a value for time, 
    % base noise n0 and frequency f
    out = n0 * sin(2 * pi * f * t);
end

