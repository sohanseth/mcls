function h = plotCO2(X, Y, YPred, Lambda, c, z, n)

landscape = true;
if landscape
    HEIGHT = 6; WIDTH = 2; ROW = 3; COL = 1;
    subplotOptions = {'left', 0.2, 'bottom', 0.05, 'row', 0.08, 'top', 0.01, 'right', 0.02};
else
    HEIGHT = 2; WIDTH = 6; ROW = 1; COL = 3;
    subplotOptions = {'left', 0.08, 'bottom', 0.2, 'column', 0.08, 'top', 0.05, 'right', 0.08};
end

h = myfigure([WIDTH HEIGHT]);
mysubplot(ROW, COL, 1, subplotOptions{:}); hold on
plot(X, Y, 'color', 'r');
plot(X, YPred, 'color', 'k')
hold off; axis tight, box off
line(X(n) * ones(1, 2), get(gca, 'ylim'), 'color', 0.8 * ones(3, 1))
% set(gca, 'xtick', [100:100:700])
myxylabel('year', 'CO2 concentraion', '');
HL = mylegend('true', 'fitted', 'location', 'northwest');
set(HL, 'edgecolor', 'none', 'color', 'none');

% breakAxis(gca, [300 500])
f = @(x)(sign(x) .* abs(x).^(3/10));
invf = @(x)(sign(x) .* abs(x).^(10/3));
YLIM = ceil(max([1.96 * sqrt(Lambda(:)); abs(c(:))]));
LAMBDAVALS = f(1.96 * sqrt(flipud(Lambda)) / YLIM);
CVALS = f(flipud(c) / YLIM);

mysubplot(ROW, COL, 2, subplotOptions{:})
hold on;
plot(LAMBDAVALS, '-r');
plot(-LAMBDAVALS,' -r');
stem(CVALS, 'color', 0.5 * [1 1 1], 'marker', '.');
hold off
axis tight, box off
set(gca, 'ylim', f([-1 1]), 'ytick', [-1:0.5:1], 'yticklabel', round(10*invf([-1:0.5:1])) / 10)
myxylabel('i', sprintf('c (\\div %d)', YLIM), '');
HL = mylegend({'$\pm 1.96\lambda^{0.5}_i$'}, 'location', 'northeast', 'interpreter', 'latex');
set(HL, 'edgecolor', 'none', 'color', 'none');

mysubplot(ROW, COL, 3, subplotOptions{:});
hold on;
plot((-5:0.1:5), normcdf(-5:0.1:5), '--r');
myecdf(z); h = get(gca, 'children'); size(h); set(h(1), 'color', 'k')
hold off;
axis tight, box off;
set(gca, 'xlim', [-5 5], 'ylim', [0 1])
myxylabel('z', 'F(z)', '');
%HL = mylegend('prior', ['agg. ', newline, 'post.'], 'location', 'southeast');
HL = mylegend('prior', 'agg. post.', 'location', 'southeast');
POS = get(HL, 'position'); set(HL, 'position', [POS(1)+0.1, POS(2)-0.02, POS(3:4)])
set(HL, 'edgecolor', 'none', 'color', 'none');

[~, p] = kstest(z);
fprintf('p = %e\n', p(end));
text(-4, 0.8, sprintf('p = %0.1e', p(end)), 'fontsize', 8, 'fontname', 'palatino')