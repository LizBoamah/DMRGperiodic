function H = mpo_to_hamiltonian(MPO)
% Converts MPO to Hamiltonian matrix
% Input:
%   MPO: cell array containing MPO tensors
% Output:
%   H: Hamiltonian matrix
   
N = length(MPO);
d = size(MPO{1}, 2);

% Calculate the total Hilbert space dimension
hilbert_dim = d^N;

% Initialize Hamiltonian matrix
H = zeros(hilbert_dim);

% Loop over all basis states
for state_dec = 0:(hilbert_dim-1)
    state_bin = dec2bin(state_dec, N) - '0';
    bra = state_bin + 1;
    
    for new_state_dec = 0:(hilbert_dim-1)
        new_state_bin = dec2bin(new_state_dec, N) - '0';
        ket = new_state_bin + 1;
        
        coef = 1;
        bond_idx1 = ones(1, N);
        bond_idx2 = ones(1, N);
        for i = 1:N
            D1 = size(MPO{i}, 1);
            D2 = size(MPO{i}, 4);
            local_coef = 0;
            for b1 = 1:D1
                for b2 = 1:D2
                    local_coef = local_coef + MPO{i}(b1, bra(i), ket(i), b2) * bond_idx1(i) * bond_idx2(i);
                end
            end
            coef = coef * local_coef;
            bond_idx1(i) = mod(bond_idx1(i), D1) + 1;
            bond_idx2(i) = mod(bond_idx2(i), D2) + 1;
        end
        
        H(state_dec+1, new_state_dec+1) = coef;
    end
end
end

% function H = mpo_to_hamiltonian(MPO)
% % Converts MPO to Hamiltonian matrix
% % Input:
% %   MPO: cell array containing MPO tensors
% % Output:
% %   H: Hamiltonian matrix
% 
% N = length(MPO);
% d = size(MPO{1}, 2);
% 
% % Calculate the total Hilbert space dimension
% hilbert_dim = d^N;
% 
% % Initialize Hamiltonian matrix
% H = zeros(hilbert_dim);
% 
% % Loop over all basis states
% for state_dec = 0:(hilbert_dim-1)
%     state_bin = dec2bin(state_dec, N) - '0';
%     bra = state_bin + 1;
%     
%     for new_state_dec = 0:(hilbert_dim-1)
%         new_state_bin = dec2bin(new_state_dec, N) - '0';
%         ket = new_state_bin + 1;
%         
%         coef = 1;
%         for i = 1:N
%             D1 = size(MPO{i}, 1);
%             D2 = size(MPO{i}, 4);
%             for bond_idx1 = 1:D1
%                 for bond_idx2 = 1:D2
%                     coef = coef * MPO{i}(bond_idx1, bra(i), ket(i), bond_idx2);
%                 end
%             end
%         end
%         
%         H(state_dec+1, new_state_dec+1) = coef;
%     end
% end
% end
% 


% function H = mpo_to_hamiltonian(MPO)
% % Converts MPO to Hamiltonian matrix
% % Input:
% %   MPO: cell array containing MPO tensors
% % Output:
% %   H: Hamiltonian matrix
% 
% N = length(MPO);
% d = size(MPO{1}, 2);
% 
% % Calculate the total Hilbert space dimension
% hilbert_dim = d^N;
% 
% % Initialize Hamiltonian matrix
% H = zeros(hilbert_dim);
% 
% % Loop over all basis states
% for state_dec = 0:(hilbert_dim-1)
%     state_bin = dec2bin(state_dec, N) - '0';
%     bra = state_bin + 1;
%     
%     for new_state_dec = 0:(hilbert_dim-1)
%         new_state_bin = dec2bin(new_state_dec, N) - '0';
%         ket = new_state_bin + 1;
%         
%         coef = 1;
%         for i = 1:N
%             coef = coef * MPO{i}(bra(i), state_bin(i)+1, ket(i), new_state_bin(i)+1);
%         end
%         
%         H(state_dec+1, new_state_dec+1) = coef;
%     end
% end
% end
% 
% 
% 
% 
% 
% 
% 


