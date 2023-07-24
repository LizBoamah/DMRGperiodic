clear
clc
% Example script to run the two_site_dmrg function

% Parameters for the Hubbard model
N = 6;             % Number of sites
P = 2;             % Local space dimension (spin up and spin down)
D = 10;            % Bond dimension
U = 1;             % Onsite interaction strength
t = 1;             % Hopping parameter
max_sweeps = 10;   % Maximum number of sweeps
 % Long range interactions
%E = [1 2; 2 3; 3 4; 4 5; 5 6;1 6]; % Nearest neighbour interactions
% tol = 1e-6;        % Convergence tolerance


% Run the two_site_dmrg function
[dmrg,E_exact,energy_sweeps, coefficients] = two_site_dmrg(N, P, D, U,t, max_sweeps);

% % % Display the final energy
%  fprintf('Ground state energy: %.6f\n', energy);

