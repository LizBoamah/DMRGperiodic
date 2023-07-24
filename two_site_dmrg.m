function [dmrg,E_exact, energy_sweeps, coefficients] = two_site_dmrg(N, P, D, U, t, max_sweeps)
    % E: Edge set 
    % numTensors: Number of tensors
    % max_sweeps: Maximum number of sweeps to perform
    % N - number of sites
    % bd - bond dimension
    % D - maximum bond dimension
    % U - onsite interaction strength
    % t - hopping parameter
    % max_sweeps - maximum number of sweeps
    % tol - convergence tolerance

    % Initialize tensor network state (MPS)
    % This often starts as a product state, which can be randomly chosen.
    % Here, the MPS is represented as a cell array of tensors.
        [E, mps] = example0( );
    % Assuming you have a TensorNetwork object named 'TN'
        numTensors = size(mps.tensor, 1); % Get the number of tensors in the TensorNetwork
        M = cell(1,numTensors);
        for index = 1:numTensors
            M{index} = mps.tensor(index).value;
        end
     % Initialize the conjugate of the tensor network state (MPS)
        M_dagger = cellfun(@conj, M, 'UniformOutput', false);

     % Construct the MPO for the Hubbard Hamiltonian
            %H = hubbard_mpo_site(U, t, N, bd, D);
            H = hubbard_mpo_site(U, t, N, P, D);
           
            Hmatrix = mpo_to_hamiltonian(H);
            [~,E_exact] = exact_diagonalization(Hmatrix);
            % Initialize the energy_sweeps vector
              energy_sweeps = zeros(max_sweeps, 1);
            
    for sweep = 1:max_sweeps
        % Forward sweep
        for i = 1:size(E, 1)
            edge = E(i, :);
                [left_env,middle_env, right_env] = contract_environments(M, M_dagger, H, edge, numTensors);
                effective_H = build_effective_hamiltonian(left_env, H{edge(1)}, H{edge(2)}, right_env, middle_env);
               % Diagonalize the effective Hamiltonian
                [eig_vec, eig_val] = eig((effective_H + effective_H')/2);
                energy_new = min(diag(eig_val));
                idx = find(diag(eig_val) == energy_new, 1);
                psi = eig_vec(:, idx);
            
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
        for i = size(E,1):-1:1
            edge = E(i, :);
            [left_env,middle_env, right_env] = contract_environments(M, M_dagger, H, edge, numTensors);
            effective_H = build_effective_hamiltonian(left_env, H{edge(1)}, H{edge(2)}, right_env, middle_env);
            
            % Diagonalize the effective Hamiltonian
            [eig_vec, eig_val] = eig((effective_H + effective_H')/2);
            energy_new = min(diag(eig_val));
            idx = find(diag(eig_val) == energy_new, 1);
            psi = eig_vec(:, idx);
            
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
          

        % Convergence check, if the energy difference (or some other measure) is below a certain threshold, break the loop
%         if sweep > 1 && abs(energy_new - energy_old) < 1e-5
%             break;
%         end
%         energy_old = energy_new;
% Store the energy of this full sweep
         energy_sweeps(sweep) = energy_new;
    end

    dmrg = M;  % Final MPS state
end






























































































