function result = focus_vector(a, b, lambda)
    k = [cos(a)*cos(b); cos(a)*sin(b); sin(a)];
    
    % 1  2
    %
    % 4  3
    
    r{1} = [-lambda/2, lambda/2, 0];
    r{2} = [lambda/2, lambda/2, 0];
    r{3} = [lambda/2, -lambda/2, 0];
    r{4} = [-lambda/2, -lambda/2, 0];
    
    phi = nan(4,1);
    
    for i=1:4
        phi(i)=2*pi*r{i}*k;
    end
    
    result = exp(1i * phi);
end

