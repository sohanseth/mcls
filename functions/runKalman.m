function samples = runKalman(Y, K, model, monitorparams)
% Defining some MCMC parameters for JAGS
% Set initial values for latent variable in each chain
nchains  = 1; % How Many Chains?
nburnin  = 10000; % How Many Burn-in Samples?
nsamples = 1000;  % How Many Recorded Samples?

switch model
    case 'kalman.txt'
        monitorparams = {'X', 'A', 'B', 'tauA', 'tauB', 'tauX', 'tauY'};
    case 'kalmanswitch.txt'
        monitorparams = {'X', 'A', 'B', 'tauA', 'tauB', 'tauX', 'tauY', 'Z', 'p'};
end
[M, N] = size(Y);
% Create a single structure that has the data for all observed JAGS nodes
datastruct = struct('N', N, 'M', M, 'Y', Y, 'K', K, 'D', 2);

for i=1:nchains
    switch model
        case 'kalman.txt'
            S.X = randn(K, N);
        case 'kalmanswitch.txt'
            S.X = randn(K, N);
    end
    init0(i) = S; % init0 is a structure array that has the initial values for all latent variables for each chain
end

% Calling JAGS to sample
doparallel = 0; % do not use parallelization
% fprintf( 'Running JAGS...\n' );
% tic
[samples, stats, structArray] = matjags( ...
    datastruct, ...                     % Observed data   
    fullfile('../functions/', model), ...           % File that contains model definition
    init0, ...                          % Initial values for latent variables
    'doparallel' , doparallel, ...      % Parallelization flag
    'nchains', nchains,...              % Number of MCMC chains
    'nburnin', nburnin,...              % Number of burnin steps
    'nsamples', nsamples, ...           % Number of samples to extract
    'thin', 1, ...                      % Thinning parameter
    'dic', 1, ...                       % Do the DIC?
    'monitorparams', monitorparams, ...     % List of latent variables to monitor
    'savejagsoutput' , 1 , ...          % Save command line output produced by JAGS?
    'verbosity' , 1 , ...               % 0=do not produce any output; 1=minimal text output; 2=maximum text output
    'cleanup' , 0 ,...                  % clean up of temporary files?
    'rndseed',1)                        % Randomise seed; 0=no; 1=yes
% toc