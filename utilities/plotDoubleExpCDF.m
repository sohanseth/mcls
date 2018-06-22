function [h, x, y] = plotDoubleExpCDF(tau)

if nargin < 1
    tau = 1;
end
x = -40:0.01:40;
y = (exp(x * tau) * 0.5) .* double(x <= 0) + (1 - exp(- x * tau) * 0.5) .* double(x > 0);
h = plot(x, y, 'r--');