% =========================================================================
% Converts linear program data from the resource allocation form to the
% standard form expected by HSDLPsolver
%
%
% This function transforms a linear programming problem from the form:
%      max   c'*x
%      s.t.  Ax <= b, 0 <= x <= 1
% to the standard minimization form used in linear programming:
%      minimize    c'*x
%      subject to  A*x = b, x >= 0
%
% The transformation involves several steps:
% 1. Converting the maximization problem to a minimization problem by
%    negating the objective function coefficients.
% 2. Adding slack variables to convert inequality constraints (Ax <= b)
%    into equality constraints.
% 3. Introducing additional constraints to handle the condition x <= 1.
%
% Inputs:
%   A - Coefficient matrix for the inequality constraints (Ax <= b) of the
%       original problem.
%   b - Right-hand side vector for the inequality constraints of the
%       original problem.
%   c - Coefficient vector for the objective function of the original problem.
%
% Outputs:
%   Alp - Modified coefficient matrix for the equality constraints of the
%         transformed problem.
%   blp - Modified right-hand side vector for the equality constraints of the
%         transformed problem.
%   clp - Modified coefficient vector for the objective function of the
%         transformed problem.
%
function [Alp, blp, clp] = standardize_resource_allocation(A, b, c)
    % Number of original constraints and variables
    rng(1)
    [m, n] = size(A); 

    % Convert the maximization problem to a minimization problem
    % Negate c for minimization and append zeros for the slack variables
    clp = [-c; zeros(m + n,1)]; 

    % Add slack variables for Ax <= b constraints
    slackVars = eye(m); % m slack variables for m inequalities

    % Append slack variables to A
    A_slack = [A, slackVars, zeros(m, n)]; 

    % Add constraints for 0 <= x <= 1
    % For each x, add a new variable y such that x + y = 1, y >= 0
    upperBoundVars = eye(n); % n additional variables for upper bound constraints
    A_upperBounds = [eye(n), zeros(n,m), upperBoundVars]; 

    % Combine the modified A matrices
    Alp = [A_slack; A_upperBounds];

    % Update b to account for the new constraints
    blp = [b; ones(n, 1)];
end

