function [optimal_revenue] = ground_truth_solver(A, p, P)

[m,n] = size(A);
x = zeros(n,1); % decision variable template

for i=1:n
    bid_price = P(i);
    if bid_price > A(:,i)'*p
        x(i) = 1;
    end
end
optimal_revenue = P'*x
end

