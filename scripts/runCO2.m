%% FIRST EXPERIMENT 
% Load dataset
clearvars; SEED = 1; YEAR = 2004;

load ../data/mauna.txt
z = mauna(:,2) ~= -99.99;
year = mauna(z,1); co2 = mauna(z,2);

XTrain = year(year < YEAR); YTrain = co2(year < YEAR);
XTest = year(year > YEAR); YTest = co2(year > YEAR);
X = [XTrain; XTest]; Y = [YTrain; YTest];

filename = '../data/testGaussianProcess_CO2_1';
LABEL = 'CO2';

rng(SEED)

%% Fit Gaussian kernel to model short term trends

covfunc = {@covSEiso};
hyp.cov = [-2 -2];
hyp.lik = -2;

[hyp, fX, i] = minimize(hyp, @gp, -500, @infExact, [], covfunc, @likGauss, XTrain, YTrain - mean(YTrain));

%% Plot

[YPred, ~] = gp(hyp, @infExact, [], covfunc, @likGauss, XTrain, YTrain - mean(YTrain), X);
YPred = YPred + mean(YTrain);

sigma2 = exp(hyp.lik)^2;
Kinfer = feval(covfunc{:}, hyp.cov, XTrain) + eye(length(XTrain)) * sigma2;
Kinfer = 0.5 * (Kinfer + Kinfer');

[U, Lambda] = eig(Kinfer, 'vector');
c = U' * (YTrain - mean(YTrain));
z = diag(Lambda.^-0.5) * c;

z(Lambda <= 2 * sigma2) = []; c(Lambda <= 2 * sigma2) = []; Lambda(Lambda <= 2 * sigma2) = [];

% plotCO2(X, Y, YPred, Lambda, c, z, length(YTrain));

%% Use ML solution to start MCMC

meanPN = exp(hyp.lik).^2; varPN = meanPN; [SH_PN, IS_PN] = m2p('gamma', meanPN, varPN);
pn = prior_gamma('sh', SH_PN, 'is', IS_PN);
lik = lik_gaussian('sigma2_prior' , pn);

meanPL = exp(hyp.cov(1)); varPL = meanPL; [SH_PL, IS_PL] = m2p('gamma', meanPL, varPL);
pl = prior_gamma('sh', SH_PL, 'is', IS_PL); 

meanPM = exp(hyp.cov(2))^2; varPM = meanPM; [SH_PM, IS_PM] = m2p('gamma', meanPM, varPM);
pm = prior_gamma('sh', SH_PM, 'is', IS_PM);

gpcf = gpcf_sexp('lengthScale', SH_PL / IS_PL, ...
    'magnSigma2', SH_PM / IS_PM, ...
    'lengthScale_prior', pl, 'magnSigma2_prior', pm);

gp_init = gp_set('lik', lik, 'cf', gpcf);
sls_opt.maxiter = 50; sls_opt.mmlimits = [-15; 10];
[gp_rec, ~, ~] = gp_mc(gp_init, XTrain, YTrain - mean(YTrain), 'nsamples', 220, 'sls_opt', sls_opt);

gp_last = thin(gp_rec, 220, 1);

%% Plot

[YPred, ~] = gp_pred(gp_last, XTrain, YTrain - mean(YTrain), X);
YPred = YPred + mean(YTrain);

sigma2 = gp_last.lik.sigma2;
Kinfer = gp_cov(gp_last, XTrain, XTrain) + eye(length(XTrain)) * sigma2;
Kinfer = 0.5 * (Kinfer + Kinfer'); % enforce positive eigenvalues

[U, Lambda] = eig(Kinfer, 'vector');
c = U' * (YTrain - mean(YTrain));
z = diag(Lambda.^-0.5) * c;

z(Lambda <= 2 * sigma2) = []; c(Lambda <= 2 * sigma2) = []; Lambda(Lambda <= 2 * sigma2) = [];

% plotCO2(X, Y, YPred, Lambda, c, z, length(YTrain));
% saveas(gcf, filename); saveImage(filename, 'fontsize', 8); close(gcf)

save(filename)

%% SECOND EXPERIMENT 
% Load dataset
clearvars -except SEED YEAR;

load mauna.txt
z = mauna(:,2) ~= -99.99;
year = mauna(z,1); co2 = mauna(z,2);

XTrain = year(year < YEAR); YTrain = co2(year < YEAR);
XTest = year(year > YEAR); YTest = co2(year > YEAR);
X = [XTrain; XTest]; Y = [YTrain; YTest];

filename = '../data/testGaussianProcess_CO2_2';
LABEL = 'CO2';

rng(SEED)

%% Use periodic kernel

covfunc = {@covProd, {@covPeriodic, @covSEisoU}};
hyp.cov = [0 0 1 4];
hyp.lik = -2;

[hyp, fX, i] = minimize(hyp, @gp, -500, @infExact, [], covfunc, @likGauss, XTrain, YTrain - mean(YTrain));

%% Plot

[YPred, ~] = gp(hyp, @infExact, [], covfunc, @likGauss, XTrain, YTrain - mean(YTrain), X);
YPred = YPred + mean(YTrain);

sigma2 = exp(hyp.lik)^2;
Kinfer = feval(covfunc{:}, hyp.cov, XTrain) + eye(length(XTrain)) * sigma2;
Kinfer = 0.5 * (Kinfer + Kinfer');

[U, Lambda] = eig(Kinfer, 'vector');
c = U' * (YTrain - mean(YTrain));
z = diag(Lambda.^-0.5) * c;

z(Lambda <= 2 * sigma2) = []; c(Lambda <= 2 * sigma2) = []; Lambda(Lambda <= 2 * sigma2) = [];

% plotCO2(X, Y, YPred, Lambda, c, z, length(YTrain));

%%
meanPN = exp(hyp.lik).^2; varPN = meanPN; [SH_PN, IS_PN] = m2p('gamma', meanPN, varPN);
pn = prior_gamma('sh', SH_PN, 'is', IS_PN);
lik = lik_gaussian('sigma2_prior' , pn);

meanPL = exp(hyp.cov(1)); varPL = meanPL; [SH_PL, IS_PL] = m2p('gamma', meanPL, varPL);
pl = prior_gamma('sh', SH_PL, 'is', IS_PL);

meanPM = exp(hyp.cov(3))^2; varPM = meanPM; [SH_PM, IS_PM] = m2p('gamma', meanPM, varPM);
pm = prior_gamma('sh', SH_PM, 'is', IS_PM);

meanPP = exp(hyp.cov(2)); varPP = meanPP; [SH_PP, IS_PP] = m2p('gamma', meanPP, varPP);
pp = prior_gamma('sh', SH_PP, 'is', IS_PP);

gpcf1 = gpcf_periodic('lengthScale', SH_PL / IS_PL, ...
    'magnSigma2', SH_PM / IS_PM, 'period', SH_PP / IS_PP, ...
    'lengthScale_prior', pl, 'magnSigma2_prior', pm, 'period_prior', pp);

meanPL = exp(hyp.cov(4))^2; varPL = meanPL; [SH_PL, IS_PL] = m2p('gamma', meanPL, varPL);
pl = prior_gamma('sh', SH_PL, 'is', IS_PL);

meanPM = 1; varPM = 10^-8; [SH_PM, IS_PM] = m2p('gamma', meanPM, varPM);
pm = prior_gamma('sh', SH_PM, 'is', IS_PM);

gpcf2 = gpcf_sexp('lengthScale', SH_PL / IS_PL, ...
    'magnSigma2', SH_PM / IS_PM, ...
    'lengthScale_prior', pl, 'magnSigma2_prior', pm);

gpcf = gpcf_prod('cf', {gpcf1, gpcf2});

gp_init = gp_set('lik', lik, 'cf', gpcf);
sls_opt.maxiter = 50; sls_opt.mmlimits = [-15; 10];
[gp_rec, ~, ~] = gp_mc(gp_init, XTrain, YTrain - mean(YTrain), 'nsamples', 220, 'sls_opt', sls_opt);

gp_last = thin(gp_rec, 220, 1);

%% Plot

[YPred, ~] = gp_pred(gp_last, XTrain, YTrain - mean(YTrain), X);
YPred = YPred + mean(YTrain);

sigma2 = gp_last.lik.sigma2;
Kinfer = gp_cov(gp_last, XTrain, XTrain) + eye(length(XTrain)) * sigma2;
Kinfer = 0.5 * (Kinfer + Kinfer'); % enforce positive eigenvalues

[U, Lambda] = eig(Kinfer, 'vector');
c = U' * (YTrain - mean(YTrain));
z = diag(Lambda.^-0.5) * c;

z(Lambda <= 2 * sigma2) = []; c(Lambda <= 2 * sigma2) = []; Lambda(Lambda <= 2 * sigma2) = [];

% plotCO2(X, Y, YPred, Lambda, c, z, length(YTrain));
% saveas(gcf, filename); saveImage(filename, 'fontsize', 8); close(gcf)

save(filename)

%% THIRD EXPERIMENT 
% Load dataset
clearvars -except SEED YEAR;

load mauna.txt
z = mauna(:,2) ~= -99.99;
year = mauna(z,1); co2 = mauna(z,2);

XTrain = year(year < YEAR); YTrain = co2(year < YEAR);
XTest = year(year > YEAR); YTest = co2(year > YEAR);
X = [XTrain; XTest]; Y = [YTrain; YTest];

filename = '../data/testGaussianProcess_CO2_3';
LABEL = 'CO2';

rng(SEED)

%% Use periodic and 'linear' kernel

k1 = {@covProd, {@covPeriodic, @covSEisoU}};
k2 = @covSEiso;
k3 = @covSEiso;
covfunc = {@covSum, {k1, k2, k3}};
hyp.cov = [0 0 1 4 4 4 -2 -2];
hyp.lik = -2;

[hyp, fX, i] = minimize(hyp, @gp, -500, @infExact, [], covfunc, @likGauss, XTrain, YTrain - mean(YTrain));

%% Plot

[YPred, ~] = gp(hyp, @infExact, [], covfunc, @likGauss, XTrain, YTrain - mean(YTrain), X);
YPred = YPred + mean(YTrain);

sigma2 = exp(hyp.lik)^2;
Kinfer = feval(covfunc{:}, hyp.cov, XTrain) + eye(length(XTrain)) * sigma2;
Kinfer = 0.5 * (Kinfer + Kinfer');

[U, Lambda] = eig(Kinfer, 'vector');
c = U' * (YTrain - mean(YTrain));
z = diag(Lambda.^-0.5) * c;

z(Lambda <= 2 * sigma2) = []; c(Lambda <= 2 * sigma2) = []; Lambda(Lambda <= 2 * sigma2) = [];

% plotCO2(X, Y, YPred, Lambda, c, z, length(YTrain));

%%
meanPN = exp(hyp.lik).^2; varPN = meanPN; [SH_PN, IS_PN] = m2p('gamma', meanPN, varPN);
pn = prior_gamma('sh', SH_PN, 'is', IS_PN);
lik = lik_gaussian('sigma2_prior' , pn);

meanPL = exp(hyp.cov(1)); varPL = meanPL; [SH_PL, IS_PL] = m2p('gamma', meanPL, varPL);
pl = prior_gamma('sh', SH_PL, 'is', IS_PL);

meanPM = exp(hyp.cov(3))^2; varPM = meanPM; [SH_PM, IS_PM] = m2p('gamma', meanPM, varPM);
pm = prior_gamma('sh', SH_PM, 'is', IS_PM);

meanPP = exp(hyp.cov(2)); varPP = meanPP; [SH_PP, IS_PP] = m2p('gamma', meanPP, varPP);
pp = prior_gamma('sh', SH_PP, 'is', IS_PP);

gpcf1 = gpcf_periodic('lengthScale', SH_PL / IS_PL, ...
    'magnSigma2', SH_PM / IS_PM, 'period', SH_PP / IS_PP, ...
    'lengthScale_prior', pl, 'magnSigma2_prior', pm, 'period_prior', pp);

meanPL = exp(hyp.cov(4)); varPL = meanPL; [SH_PL, IS_PL] = m2p('gamma', meanPL, varPL);
pl = prior_gamma('sh', SH_PL, 'is', IS_PL);

meanPM = 1; varPM = 10^-8; [SH_PM, IS_PM] = m2p('gamma', meanPM, varPM);
pm = prior_gamma('sh', SH_PM, 'is', IS_PM);

gpcf2 = gpcf_sexp('lengthScale', SH_PL / IS_PL, ...
    'magnSigma2', SH_PM / IS_PM, ...
    'lengthScale_prior', pl, 'magnSigma2_prior', pm);

gpcf{1} = gpcf_prod('cf', {gpcf1, gpcf2});

meanPL = exp(hyp.cov(5)); varPL = meanPL; [SH_PL, IS_PL] = m2p('gamma', meanPL, varPL);
pl = prior_gamma('sh', SH_PL, 'is', IS_PL);

meanPM = exp(hyp.cov(6))^2; varPM = meanPM; [SH_PM, IS_PM] = m2p('gamma', meanPM, varPM);
pm = prior_gamma('sh', SH_PM, 'is', IS_PM);

gpcf{2} = gpcf_sexp('lengthScale', SH_PL / IS_PL, ...
    'magnSigma2', SH_PM / IS_PM, ...
    'lengthScale_prior', pl, 'magnSigma2_prior', pm);

meanPL = exp(hyp.cov(7)); varPL = meanPL; [SH_PL, IS_PL] = m2p('gamma', meanPL, varPL);
pl = prior_gamma('sh', SH_PL, 'is', IS_PL);

meanPM = exp(hyp.cov(8))^2; varPM = meanPM; [SH_PM, IS_PM] = m2p('gamma', meanPM, varPM);
pm = prior_gamma('sh', SH_PM, 'is', IS_PM);

gpcf{3} = gpcf_sexp('lengthScale', SH_PL / IS_PL, ...
    'magnSigma2', SH_PM / IS_PM, ...
    'lengthScale_prior', pl, 'magnSigma2_prior', pm);

gp_init = gp_set('lik', lik, 'cf', gpcf);
sls_opt.maxiter = 50; sls_opt.mmlimits = [-15; 10];
[gp_rec, ~, ~] = gp_mc(gp_init, XTrain, YTrain - mean(YTrain), 'nsamples', 220, 'sls_opt', sls_opt);

gp_last = thin(gp_rec, 220, 1);

%% Plot

[YPred, ~] = gp_pred(gp_last, XTrain, YTrain - mean(YTrain), X);
YPred = YPred + mean(YTrain);

sigma2 = gp_last.lik.sigma2;
Kinfer = gp_cov(gp_last, XTrain, XTrain) + eye(length(XTrain)) * sigma2;
Kinfer = 0.5 * (Kinfer + Kinfer'); % enforce positive eigenvalues

[U, Lambda] = eig(Kinfer, 'vector');
c = U' * (YTrain - mean(YTrain));
z = diag(Lambda.^-0.5) * c;

z(Lambda <= 2 * sigma2) = []; c(Lambda <= 2 * sigma2) = []; Lambda(Lambda <= 2 * sigma2) = [];

% plotCO2(X, Y, YPred, Lambda, c, z, length(YTrain));
% saveas(gcf, filename); saveImage(filename, 'fontsize', 8); close(gcf)

save(filename)