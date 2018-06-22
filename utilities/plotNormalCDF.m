function [h, x, y] = plotNormalCDF(tau, prop)

if nargin == 0
    tau = 1; prop = 1;
end
x = -25:0.01:25; y = zeros(size(x));
for count = 1:length(tau)
    y = y + prop(count) * normcdf(x, 0, tau(count)^(-0.5));
end
h = plot(x, y, 'r--');