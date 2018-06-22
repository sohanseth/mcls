function [EX, EY, Z] = runBeeComputeInnovation(Y, samples, D)

[M, N] = size(Y);

X = squeeze(samples.X(1, end, :, :));
B = squeeze(samples.B(1, end, :, :));
tauY = squeeze(samples.tauY(1, end, :, :));
EY = bsxfun(@(x,y)(x .* y), tauY.^0.5, (Y - B * X));

if D == 1
    A = squeeze(samples.A(1, end, :, :));
    tauX = squeeze(samples.tauX(1, end, :, :));
    EX = bsxfun(@(x,y)(x .* y), tauX.^0.5, (X(:, 2:end) - A * X(:, 1:end-1)));
end

if D > 1
    Z = squeeze(samples.Z(1, end, :, :));
    p = squeeze(samples.p(1, end, :, :));
    for d = 1:D
        A{d} = squeeze(samples.A(1, end, d, :, :));
        tauX{d} = squeeze(samples.tauX(1, end, d, :));
    end
    for count = 2:N
        EX(:, count-1) = bsxfun(@(x,y)(x .* y), tauX{Z(count)}.^0.5, (X(:, count) - A{Z(count)} * X(:, count-1)));
    end
end