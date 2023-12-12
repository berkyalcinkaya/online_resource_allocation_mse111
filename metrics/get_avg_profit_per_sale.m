function [avg_profit_per_sale] = get_avg_profit_per_sale(A,p,P,x)

n = length(x);
profits_per_sale = zeros(n,1);
for i=1:n
    revenue = P(i)*x(i);
    cost = A(:,i)'*p;
    profits_per_sale(i,1) = revenue-cost; 
end

avg_profit_per_sale = mean(profits_per_sale, "all");
end


