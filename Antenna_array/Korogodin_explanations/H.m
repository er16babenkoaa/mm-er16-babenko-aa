function Hv = H( alpha, beta ) 
 k = [cosd(alpha)*cosd(beta);
% Unit vector
cosd(alpha)*sind(beta);
sind(alpha)];
r{1} = [1/4 -1/4 0];
% Antenna's radius-vector, lambdas
r{2} = [-1/4 -1/4 0];
r{3} = [-1/4 1/4 0];
r{4} = [1/4 1/4 0];
phi = nan(4,1);
for i = 1:4
phi(i) = 2*pi * r{i} * k;
end
Hv = exp( 1i * phi );
end 