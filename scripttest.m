clear
clc
% Example script to run the two_site_dmrg function

% Parameters for the Hubbard model
N = 6;             % Number of sites
P = 2;             % Local space dimension (spin up and spin down)
D = 10;            % Bond dimension
U = 0;             % Onsite interaction strength
t = 1;             % Hopping parameter
max_sweeps = 10;   % Maximum number of sweeps
mu = 0;
% Run the two_site_dmrg function
[dmrg,E_exact,energy_sweeps, coefficients, E_DMRG] = two_site_dmrg(N, mu, D, t, max_sweeps);



