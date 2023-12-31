function [dmrg,E_exact, energy_values, coefficients, E_DMRG] = two_site_dmrg(N, mu, D,  t, max_sweeps)
    % two_site_dmrg: Solves the ground state of a 1D Hubbard model using DMRG
    % 
    % Inputs:
    %   N          : Number of lattice sites
    %   mu         : Chemical potential
    %   D          : Maximum bond dimension
    %   U          : On-site interaction strength
    %   t          : Hopping parameter between adjacent sites
    %   max_sweeps : Maximum number of DMRG sweeps
    %
    % Outputs:
    %   dmrg           : Final Matrix Product State (MPS) approximation for the ground state
    %   E_exact        : Ground state energy from exact diagonalization
    %   energy_sweeps  : Vector of energies at each sweep
    %   coefficients   : Coefficients from the singular value decomposition (SVD)
    % 
    
   
    % Initialize tensor network state and edge set using example0 function.
    % This sets up the initial configuration for our many-body quantum system.
        [E_set, mps] = example0();


    % Assuming you have a TensorNetwork object named 'TN'
        numTensors = size(mps.tensor, 1); % Get the number of tensors in the TensorNetwork
        M = cell(1,numTensors);
        for index = 1:numTensors
            M{index} = mps.tensor(index).value;
        end
        
     % Initialize the conjugate of the tensor network state (MPS)
        numTensors = length(M);  % Assuming M is a 1D cell array
        M_dagger = cell(1, numTensors);

        for i = 1:numTensors
            M_dagger{i} = conj(M{i});
        end
         % Compute the overlap (inner product) of MPS with itself
           overlap = compute_overlap(M);
             % Normalize MPS tensors
            for i = 1:length(M)
                M{i} = M{i} / sqrt(overlap);
            end
            
            % Update the conjugate
            for i = 1:length(M)
                M_dagger{i} = conj(M{i});
            end


         

     % Construct the MPO for the Hubbard Hamiltonian
            H = hubbard_mpo_site(t,mu, N);
            Hmatrix = mpo_to_hamiltonian(H);
            [~,E_exact] = exact_diagonalization(Hmatrix);
            % % Initialize the energy_sweeps vector  [Energy after forward sweep, Energy after backward sweep]
            %   energy_values = zeros(max_sweeps, 2);
            % Instead of storing only 2 energies per sweep, store them for each tensor optimization.
    energy_values = zeros(max_sweeps * size(E_set, 1), 2); 

    for sweep = 1:max_sweeps
        % Forward sweep
        for i = 1:size(E_set, 1)
            edge = E_set(i, :);
                [left_env,middle_env, right_env] = contract_environments(M, M_dagger, H, edge, numTensors);
                effective_H = build_effective_hamiltonian(left_env, H{edge(1)}, H{edge(2)}, right_env, middle_env);

               % Diagonalize the effective Hamiltonian
                [eig_vec, eig_val] = eig((effective_H + effective_H')/2);
                energy_new1 = min(diag(eig_val));
                idx = find(diag(eig_val) == eig_val, 1);
                psi = eig_vec(:, idx);

                % % Store the energy after the forward sweep
                % energy_values(sweep, 1) = energy_new1;
            % Store the energy after each tensor optimization during forward sweep
            energy_values((sweep-1) * size(E_set, 1) + i, 1) = energy_new1;

                % Reshape psi and perform SVD
                psi_matrix = reshape(psi, [size(M{edge(1)}, 1) * size(M{edge(1)}, 2), size(M{edge(2)}, 2) * size(M{edge(2)}, 3)]);
                [U, S, V] = svd(psi_matrix, 'econ');
                coefficients = diag(S);

            % Truncate to maximum bond dimension D
                if size(U, 2) > D
                    U = U(:, 1:D);
                    S = S(1:D, 1:D);
                    V = V(:, 1:D);
                end
                % Update M and M_dagger using the ground state wavefunction
                % This typically involves reshaping psi and possibly performing an SVD to maintain the MPS form
                M{edge(1)} = reshape(U, [size(M{edge(1)}, 3), size(M{edge(1)}, 2), size(S, 1)]);
                M{edge(2)} = reshape(S*V', [size(S, 2), size(M{edge(2)}, 2), size(M{edge(2)}, 3)]);
            
                % Update the conjugate MPS tensor M_dagger
                M_dagger{edge(1)} = conj(M{edge(1)});
                M_dagger{edge(2)} = conj(M{edge(2)});
            
        end
        
        % Backward sweep
        for i = size(E_set,1):-1:1
            edge = E_set(i, :);
            [left_env,middle_env, right_env] = contract_environments(M, M_dagger, H, edge, numTensors);
            effective_H = build_effective_hamiltonian(left_env, H{edge(1)}, H{edge(2)}, right_env, middle_env);
            
            % Diagonalize the effective Hamiltonian
            [eig_vec, eig_val] = eig((effective_H + effective_H')/2);
            energy_new2 = min(diag(eig_val));
            idx = find(diag(eig_val) == eig_val, 1);
            psi = eig_vec(:, idx);

            % % Store the energy after the backward sweep
            %  energy_values(sweep, 2) = energy_new2;
            % Store the energy after each tensor optimization during backward sweep
            energy_values((max_sweeps - sweep) * size(E_set, 1) + i, 2) = energy_new2;

            % Reshape psi and perform SVD
            psi_matrix = reshape(psi, [size(M{edge(1)}, 1) * size(M{edge(1)}, 2), size(M{edge(2)}, 2) * size(M{edge(2)}, 3)]);
            [U, S, V] = svd(psi_matrix, 'econ');
            
            % Truncate to maximum bond dimension D
            if size(U, 2) > D
                U = U(:, 1:D);
                S = S(1:D, 1:D);
                V = V(:, 1:D);
            end
    
            % Update M and M_dagger using the ground state wavefunction
            M{edge(1)} = reshape(U, [size(M{edge(1)}, 3), size(M{edge(1)}, 2), size(S, 1)]);
            M{edge(2)} = reshape(S*V', [size(S, 2), size(M{edge(2)}, 2), size(M{edge(2)}, 3)]);
            
            % Update the conjugate MPS tensor M_dagger
            M_dagger{edge(1)} = conj(M{edge(1)});
            M_dagger{edge(2)} = conj(M{edge(2)});
        end
          
    
   end

    dmrg = M;  % Final MPS state
    % E_DMRG= min(energy_values);  % The last energy value after the final backward sweep
     E_DMRG = energy_values(end, 2);  % The last energy value after the final backward sweep
end






























































































