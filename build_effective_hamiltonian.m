function effective_H = build_effective_hamiltonian(left_env, H_edge1, H_edge2, right_env, middle_env)
    % Case 1: Check if both left_env and right_env are 1
   if isscalar(left_env) && all(left_env == 1) && isscalar(right_env) && all(right_env == 1) && exist('middle_env', 'var') && ~isempty(middle_env)
        %Contract the MPO tensor at edge1 with the middle environment
        temp1 = tensorprod(H_edge1, middle_env, 1, 2);

        % Contract the resulting tensor with the MPO tensor at edge2
        effective_H = tensorprod(temp1, H_edge2, 6, 3);

        % Calculate sizes for the reshaping operation
         siz1 = (size(effective_H, 3)*size(effective_H, 7)*size(effective_H, 6)*size(effective_H, 8));
         siz2 = (size(effective_H, 2)*size(effective_H, 4)*size(effective_H, 5)*size(effective_H, 1));
        
    % Case 2: Check if left_env is 1
    elseif left_env == 1
        temp1 = tensorprod(left_env, H_edge1, 2, 4);

        % Contract the resulting tensor with the MPO tensor at edge2
        temp2 = tensorprod(right_env, H_edge2, 4, 4);

        % Finally, contract the result with the right environment
        effective_H = tensorprod(temp1, temp2, 4, 5);

        % Calculate sizes for the reshaping operation
        siz1 = (size(effective_H, 3)*size(effective_H, 7)*size(effective_H, 6)*size(effective_H, 8)*size(effective_H, 1));
        siz2 = (size(effective_H, 2)*size(effective_H, 4)*size(effective_H, 5)*size(effective_H, 9)*size(effective_H, 10));
        
        
    % Case 3: Check if right_env is 1
    elseif right_env == 1
           temp1 = tensorprod(left_env, H_edge1, 4, 1);

        % Contract the resulting tensor with the MPO tensor at edge2
        temp2 = tensorprod(right_env, H_edge2, 2, 4);

        % Finally, contract the result with the right environment
        effective_H = tensorprod(temp1, temp2, 7, 2);

        % Calculate sizes for the reshaping operation
        siz1 = (size(effective_H, 3)*size(effective_H, 7)*size(effective_H, 6)*size(effective_H, 8)*size(effective_H, 1));
        siz2 = (size(effective_H, 2)*size(effective_H, 4)*size(effective_H, 5)*size(effective_H, 9)*size(effective_H, 10));
        
      %will be added later   
%     % Case 4: Check if middle_env exists (and left_env and right_env are not 1)
%     elseif exist('middle_env', 'var') && ~isempty(middle_env) && left_env ~= 1 && right_env ~= 1
%         % similar code as in your original case 3

    % Case 5: General case
    else
         %Contract the left environment with the MPO tensor at edge1
        temp1 = tensorprod(left_env, H_edge1, 2, 4);
        
        % Contract the resulting tensor with the MPO tensor at edge2
        temp2 = tensorprod(right_env, H_edge2, 5, 4);
        
        % Finally, contract the result with the right environment
        effective_H = tensorprod(temp1, temp2, [1,2,5], [2,4,5]);
         effective_H = permute(effective_H, [1,3,7,5,2,4,8,6]);

          % Calculate sizes for the reshaping operation
         siz1 = (size(effective_H, 1)*size(effective_H, 3)*size(effective_H, 8)*size(effective_H, 6));
         siz2 = (size(effective_H, 2)*size(effective_H, 4)*size(effective_H, 5)*size(effective_H, 7));
   
    end

    effective_H = reshape(effective_H, siz1, siz2);
end



















% function effective_H = build_effective_hamiltonian(left_env, H_edge1, H_edge2, right_env, middle_env)
% 
%     % If the middle_env exists, i.e., if we're dealing with the special case
%     if exist('middle_env', 'var') && ~isempty(middle_env)
%         % Contract the MPO tensor at edge1 with the middle environment
%         temp1 = tensorprod(H_edge1, middle_env, 2, 2);
% 
%         % Contract the resulting tensor with the MPO tensor at edge2
%         effective_H = tensorprod(temp1, H_edge2, 6, 1);
% 
%         % Calculate sizes for the reshaping operation
%          siz1 = (size(effective_H, 3)*size(effective_H, 7)*size(effective_H, 6)*size(effective_H, 8));
%          siz2 = (size(effective_H, 2)*size(effective_H, 4)*size(effective_H, 5)*size(effective_H, 1));
%     else
%         % For all other cases, do as before
%         % Contract the left environment with the MPO tensor at edge1
%         temp1 = tensorprod(left_env, H_edge1, 2, 4);
% 
%         % Contract the resulting tensor with the MPO tensor at edge2
%         temp2 = tensorprod(right_env, H_edge2, 4, 4);
% 
%         % Finally, contract the result with the right environment
%         effective_H = tensorprod(temp1, temp2, 2, 5);
% 
%         % Calculate sizes for the reshaping operation
%         siz1 = (size(effective_H, 3)*size(effective_H, 7)*size(effective_H, 6)*size(effective_H, 8)*size(effective_H, 1));
%         siz2 = (size(effective_H, 2)*size(effective_H, 4)*size(effective_H, 5)*size(effective_H, 9)*size(effective_H, 10));
%     end
% 
%     effective_H = reshape(effective_H, siz1, siz2);
% end
% 
% 
% 
% 



































 






















































































































