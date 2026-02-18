% for slack/surplus variable it shouldn't be present in any other constraint

% max z = 2x1 + 3x2 + 4x3 + 5x4
% x1 + 2x2+ x3+ x4 = 10
% 2x1 + x2 + 3x3 + 2x4 = 15
% x1,x2,x3,x4 >= 0

% This can't be solved using graphical as no. of variables are greater than 2
% So we use BFS that can be used for any no. of variables
% Conditions for BFS is n >= m -- (no. of constraints)
%                       |
%               (no. of variables)

% n-m = 2 (for this question)--> zero variables needed in each constraint
% ncm = 6 = total  no. of basic solutions
% So we need to solve 6 cases in total


% ==============================================================================
% Case       | x1      | x2      | x3      | x4      | z       | Status
% ==============================================================================
% Case 1     | 20/3    | 5/3     | 0       | 0       | 18.33   |
% Case 2     | 15      | 0       | -5      | 0       |         | Infeasible
% Case 3     | 0       | 3       | 4       | 0       | 25      |
% Case 4     |    -    | 0       | 0       |    -    |         | Inconsistent
% Case 5     | 0       | 5/3     | 0       | 20/3    | 38.33   |
% Case 6     | 0       | 0       | -5      | 15      |         | Infeasible
% ==============================================================================

% Agar inequality is given then first convert to equality


% BFS
A = [1, 2, 1, 1; 2, 1, 3, 2];    % Coefficient matrix (m x n)
B = [10; 15];        % RHS vector (m x 1)
C = [2, 3, 4, 5];    % Objective function coefficients (1 x n)

n = size(A, 2);
m = size(A, 1);

if n >= m
    ncm = nchoosek(n, m);
    p = nchoosek(1:n, m);
    sol = [];
    for i = 1:ncm
        y = zeros(n, 1);  % Fixed: 'zeroes' -> 'zeros'
        A1 = A(:, p(i, :));  % Fixed: added missing closing parenthesis
        if det(A1) ~= 0  % Fixed: moved closing parenthesis, added space in ~=
            X = inv(A1) * B;
            if all(X >= 0)
                y(p(i, :)) = X;
                sol = [sol y];
            end
        end
    end
    Z = C * sol;
    [optval, idx] = max(Z);  % Fixed: added comma between outputs
    optsol = sol(:, idx);
    opt = [optsol; optval];  % Fixed: changed to semicolon for vertical concatenation
    array2table(opt', 'VariableNames', {'x1', 'x2', 'x3', 'x4', 'Z'})  % Added transpose
else
    error('Number of variables must be >= number of constraints');
end

% DFS
