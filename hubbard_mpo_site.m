function MPO = hubbard_mpo_site(U, t, N, P, D)
    % Constructs the MPO tensor for the Hubbard Hamiltonian in the second
    % quantized form for a one-dimensional chain of N sites.
    % Input:
    %   U: onsite interaction strength
    %   t: hopping parameter
    %   N: number of sites
    %   P: physical dimension
    %   D: bond dimension
    % Output:
    %   MPO: cell array containing MPO tensors

    % Identity and fermion creation/annihilation matrices
    I = eye(P);
    c_up = [0, 1; 0, 0];
    c_down = [0, 0; 1, 0];
    n_up = c_up' * c_up;
    n_down = c_down' * c_down;

    % Construct MPO tensors
    MPO = cell(1, N); 
    for i = 1:N
        if i == 1
            W = zeros(P, P, D);
            W(:, :, 1) = I;
            W(:, :, 2) = c_up;
            W(:, :, 3) = c_down;
            W(:, :, 4) = -t * c_up' * c_down;
        elseif i == N
            W = zeros(D, P, P);
            W(1, :, :) = I;
            W(2, :, :) = c_up;
            W(3, :, :) = c_down;
            W(4, :, :) = -t * c_down' * c_up + U * n_up * n_down;
        else
            W = zeros(D, P, P, D);
            W(1, :, :, 1) = I;
            W(1, :, :, 2) = c_up;
            W(1, :, :, 3) = c_down;
            W(1, :, :, 4) = -t * c_up' * c_down;
            for j = 2:(D-1)
                W(j, :, :, j+1) = I;
            end
            W(D, :, :, D) = -t * c_down';
            W(D, :, :, D) = squeeze(W(D, :, :, D)) + U * n_up;
            W(D, :, :, D) = squeeze(W(D, :, :, D)) + U * n_down;
        end
        MPO{i} = W;
    end
end




































% function MPO = hubbard_mpo_site(U, t, N, d, D)
% % Constructs the MPO tensor for the Hubbard Hamiltonian in the second
% % quantized form for a one-dimensional chain of N sites.
% % Input:
% %   U: onsite interaction strength
% %   t: hopping parameter
% %   N: number of sites
% %   d: bond dimension
% % Output:
% %   MPO: cell array containing MPO tensors
% 
% % Create MPO for Hubbard Hamiltonian
% MPO = cell(1, N);
% % d = 2;
% % D= 10;
% 
% % Identity and fermion creation/annihilation matrices
% I = eye(2);
% c_up = [0, 1; 0, 0];
% c_down = [0, 0; 1, 0];
% n_up = c_up' * c_up;
% n_down = c_down' * c_down;
% 
% % Construct MPO tensors
% for i = 1:N
%     if i == 1
%         W = zeros(1, D, d, d);
%         W(1, 1, :, :) = I;
%         W(1, 2, :, :) = c_up;
%         W(1, 3, :, :) = c_down;
%         W(1, 4, :, :) = -t * c_up' * c_down;
%     elseif i == N
%         W = zeros(D, d, d, 1);
%         W(1, :, :, 1) = I;
%         W(2, :, :, 1) = c_up;
%         W(3, :, :, 1) = c_down;
%         W(4, :, :, 1) = -t * c_down' * c_up + U * n_up * n_down;
%     else
%         W = zeros(D, D, d, d);
%         W(1, 1, :, :) = I;
%         W(1, 2, :, :) = c_up;
%         W(1, 3, :, :) = c_down;
%         W(1, 4, :, :) = -t * c_up' * c_down;
%         for j = 2:(d-1)
%             W(j, :, :, j+1) = I;
%         end
%         W(D, D, :, :) = -t * c_down';
%         W(D, D, :, :) = squeeze(W(D, D, :, :)) + U * n_up;
%         W(D, D, :, :) = squeeze(W(D, D, :, :)) + U * n_down;
%     end
%     MPO{i} = W;
% end
% end






































% function MPO = hubbard_mpo_site(U, t, N, P, D)
%     % Constructs the MPO tensor for the Hubbard Hamiltonian in the second
%     % quantized form for a one-dimensional chain of N sites with PBCs.
%     % Input:
%     %   U: onsite interaction strength
%     %   t: hopping parameter
%     %   N: number of sites
%     %   P: physical dimension
%     %   D: bond dimension
%     % Output:
%     %   MPO: cell array containing MPO tensors
% 
%     % Identity and fermion creation/annihilation matrices
%     I = eye(P);
%     c_up = [0, 1; 0, 0];
%     c_down = [0, 0; 1, 0];
%     n_up = c_up' * c_up;
%     n_down = c_down' * c_down;
% 
%     % Construct MPO tensors
%     MPO = cell(1, N);
%     for i = 1:N
%         if i == 1
%             W = zeros(D, P, P, D);
%             W(1, :, :, 1) = I;
%             W(1, :, :, 2) = c_up;
%             W(1, :, :, 3) = c_down;
%             W(1, :, :, 4) = -t * c_up' * c_down;
%             W(D, :, :, D) = -t * c_down';  % Additional term for PBC
%         elseif i == N
%             W = zeros(D, P, P, D);
%             W(1, :, :, 1) = I;
%             W(2, :, :, 1) = c_up;
%             W(3, :, :, 1) = c_down;
%             W(4, :, :, 1) = -t * c_down' * c_up + U * n_up * n_down;
%             W(D, :, :, D) = -t * c_up';  % Additional term for PBC
%         else
%             W = zeros(D, P, P, D);
%             W(1, :, :, 1) = I;
%             W(1, :, :, 2) = c_up;
%             W(1, :, :, 3) = c_down;
%             W(1, :, :, 4) = -t * c_up' * c_down;
%             for j = 2:(D-1)
%                 W(j, :, :, j+1) = I;
%             end
%             W(D, :, :, D) = -t * c_down';
%             W(D, :, :, D) = squeeze(W(D, :, :, D)) + U * n_up;
%             W(D, :, :, D) = squeeze(W(D, :, :, D)) + U * n_down;
%         end
%         MPO{i} = W;
%     end
% end
















































% function MPO = hubbard_mpo_site(U, t, N, P, D)
% % Constructs the MPO tensor for the Hubbard Hamiltonian in the second
% % quantized form for a one-dimensional chain of N sites.
% % Input:
% %   tprime = hopping parameter for long-range interaction
% %   E_conn = Lx2 matrix where each row [i j]  respresents a long- range
% %   interaction
% %   U: onsite interaction strength
% %   t: hopping parameter
% %   N: number of sites
% %   d: bond dimension
% % Output:
% %   MPO: cell array containing MPO tensors
% 
% % Create MPO for Hubbard Hamiltonian
% MPO = cell(1, N);
% % d = 2;
% % D= 10;
% 
% % Identity and fermion creation/annihilation matrices
% I = eye(2);
% c_up = [0, 1; 0, 0];
% c_down = [0, 0; 1, 0];
% n_up = c_up' * c_up;
% n_down = c_down' * c_down;
% 
% % Construct MPO tensors
% for i = 1:N
% %     % Check if the current site is involved in any long-range interactions
% %     [lr_idx, ~] = find(E_conn == i);
% 
%     % Initialize MPO tensor 
%     if i == 1
%         W = zeros(1, P, P, D);
%         W(1, :, :, 1) = I;
%         W(1, :, :, 2) = c_up;
%         W(1, :, :, 3) = c_down;
%         W(1, :, :, 4) = -t * c_up' * c_down;
%     elseif i == N
%         W = zeros(D, P, P, 1);
%         W(1, :, :, 1) = I;
%         W(2, :, :, 1) = c_up;
%         W(3, :, :, 1) = c_down;
%         W(4, :, :, 1) = -t * c_down' * c_up + U * n_up * n_down;
%     else
%         W = zeros(D, P, P, D);
%         W(1, :, :, 1) = I;
%         W(1, :, :, 2) = c_up;
%         W(1, :, :, 3) = c_down;
%         W(1, :, :, 4) = -t * c_up' * c_down;
%         for j = 2:(P-1)
%             W(j, :, :, j+1) = I;
%         end
%         W(D, :, :, D) = -t * c_down';
%         W(D, :, :, D) = squeeze(W(D, :, :, D)) + U * n_up;
%         W(D, :, :, D) = squeeze(W(D, :, :, D)) + U * n_down;
%     end
% %      If site is involved in long-range interactions, add the corresponding terms
% % for idx = lr_idx.'
% %     if E_conn(idx, 1) == i
% %         W(1, :, :, D) = W(1, :, :, D) - tprime * reshape(c_up, [1, d, d]);  % long-range term
% %     else
% %         W(D, :, :, 1) = W(D, :, :, 1) + tprime * reshape(c_up', [1, d, d]);  % long-range term conjugate
% %     end
% end
% 
%      MPO{i} = W;
% end




























