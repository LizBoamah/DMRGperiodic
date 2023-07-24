function mps = init_random_mps(N, d, D)
% Initialize a random MPS of N sites
% N: number of sites
% d: physical dimension (e.g., 2 for spin-1/2, 3 for spin-1, etc.)
% D: bond dimension

% Preallocate an empty cell array to store the MPS tensors
mps = cell(1, N);

for it = (1:N)
% assign individual tensors
% leg order: left, bottom, right
    if it == 1
        % left end; left leg is of size 1
        mps{it} = rand(1,d,D);
    elseif it == N
        % right end; right leg is of size 1
        mps{it} = rand(D,d,1);
    else
        mps{it} = rand(D,d,D);
    end
end

% Normalize each MPS tensor
for it = 1:N
    mps{it} = mps{it} / norm(mps{it}(:));
end
