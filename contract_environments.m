function [left_env, middle_env, right_env] = contract_environments(M, M_dagger, H, edge, numTensors)
    % Special case for edge = [N 1]
    middle_env = [];
    if edge(1) == numTensors && edge(2) == 1
        % Initialize left_env, right_env and middle_env
        left_env = 1;
        right_env = 1;

        middle_env = tensorprod(M{2}, H{2}, 2,2);
        middle_env = tensorprod(middle_env, M_dagger{2}, 4,2);

        % Contract the rest of the tensors from 3 to N-1
        for i = 3:(numTensors-1)
            temp_env = tensorprod(M{i}, H{i}, 2,2);
            temp_env = tensorprod(temp_env, M_dagger{i}, 4,2);
            middle_env = tensorprod(middle_env, temp_env, [4, 5, 6], [1,3 ,5]);
        end
    else
        if edge(1) == 1
              left_env = 1;
        else
              % Contract the left environment
                left_env = tensorprod(M{1}, H{1}, 2,1);
                left_env = tensorprod(left_env, M_dagger{1},3 ,2);
        end
        % Contract the rest of the tensors up to the edge
        for i = 2:edge(1)-1
            temp_env = tensorprod(M{i}, H{i}, 2, 2);
            temp_env = tensorprod(temp_env, M_dagger{i}, 4, 2);
            left_env = tensorprod(left_env, temp_env, [3, 4 ,5], [1, 3, 5]);
        end
        if edge(2) == numTensors
            right_env = 1;
        else
            % Contract the right environment
            right_env = tensorprod(M{numTensors}, H{numTensors}, 2, 2);
            right_env = tensorprod(right_env, M_dagger{numTensors}, 4,2);
        end
            % Contract the rest of the tensors from the end to the edge
    for i = (numTensors-1):-1:(edge(2)+1)
        temp_env = tensorprod(M{i}, H{i}, 2,2);
        temp_env = tensorprod(temp_env, M_dagger{i}, 4,2);
        right_env = tensorprod(right_env, temp_env,[3, 4, 5], [2, 4, 6]);
    end
    end
end





































  




























