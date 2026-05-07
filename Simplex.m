clc;
clear all;

%% Initial Table Formation
a = [1, 2, 2; 2, 4, 1]; % Constraints Coefficient
B = [10; 15]; % Constraints Solution
C = [5, 2, 3]; % Objective Function Coefficient
n = 3; % No. of variables excluding slack variable
s = eye(size(a, 1)); % Slack Variable Coefficient
A = [a, s, B];
cost = zeros(1, size(A, 2));
cost(1 : n) = C;
BV = n + 1 : 1 : size(A, 2) - 1;
zjcj = cost(BV) * A - cost;
Z = [A; zjcj];
Z = array2table(Z, 'VariableNames', {'x1', 'x2', 'x3', 's1', 's2', 'sol'});
Z

%% Simplex Iteration
Run = true;
while Run
    zc = zjcj(1 : end - 1);
    if any(zc < 0)
        fprintf('The current solution is not optimal');
        [Minimal , pvt_col] = min(zc);
        if all(A(:, pvt_col) <= 0)
            fprintf('The given LPP is unbounded');
        else
            sol = A(:, end);
            col = A(:, pvt_col);
            for i = 1 : size(A, 1)
                if col(i) > 0
                    ratio(i) = sol(i) / col(i);
                else
                    ratio(i) = Inf;
                end
            end
            [minratio, pvt_row] = min(ratio);
        end
        pvt_key = A(pvt_row, pvt_col);
        BV(pvt_row) = pvt_col;
        A(pvt_row, :) = A(pvt_row, : ) / pvt_key;
        for i = 1 : size(A, 1)
            if i ~= pvt_row
                A(i, :) = A(i, :) - A(i, pvt_col) * A(pvt_row, :);
            end
        end
        zjcj = zjcj - zjcj(pvt_col) * A(pvt_row, :);
        Z = [A; zjcj];
        Z = array2table(Z, 'VariableNames', {'x1', 'x2', 'x3', 's1', 's2', 'sol'});
        Z
    else
        Run = false;
        fprintf('The current solution is optimal');
    end
end