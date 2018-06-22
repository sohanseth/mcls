function [f, x] = myecdf(data)

[f, x] = ecdf(data);
f = [0; f; 1]; x = [min(x) - 100; x; max(x) + 100];
% stairs(x, f)
if nargout < 1
    plot(x, f)
end