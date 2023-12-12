
function [optimal_value,x, estimated_shadow_price] = onetime_online_learning_solver(A,b,c,k)
[m,n] = size(A);
x = zeros(n,1); % decision variable template
shadow_price = get_shadow_price(A,b,c,k,n);
b_remaining = b;

% for remaining bids, make decision based on calculated shadow price
for i=(k+1):n
    bid_price = c(i);
    a_i = A(:,i);
    if bid_price > a_i'*shadow_price
        if ~(any(b_remaining(a_i==1)==0))
            x(i) = 1;
            b_remaining = b_remaining - a_i;
        end
    end
end

optimal_value = c'*x;
estimated_shadow_price = shadow_price;

end


      


