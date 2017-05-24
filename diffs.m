function dY = diffs( t, Y )
    %dY = Y*cot(t)+4*t*sin(t);
    dY = (Y/(t-2)) + 2*(t-2)*exp(2*t);
end

