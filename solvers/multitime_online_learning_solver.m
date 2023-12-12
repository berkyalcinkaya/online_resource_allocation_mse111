function [optimal_value, shadow_prices, k_updates,x] = multitime_online_learning_solver(A,b,c)

[m,n] = size(A);
x = zeros(n,1); % decision variable template

k_updates = generateSeries(n);
k_index = 1;
initial_sp_calculated = 0;
shadow_prices = zeros(m,length(k_updates));
% for remaining bids, make decision based on calculated shadow price
b_remaining = b;
for i=1:n
    if (i == k_updates(k_index))
        shadow_price = get_shadow_price(A,b,c,k_updates(k_index),n);
        shadow_prices(:,k_index) = shadow_price;
        k_index = min(k_index + 1,length(k_updates));
        initial_sp_calculated  = 1;
    end

    if (initial_sp_calculated)
        bid_price = c(i);
        a_i = A(:,i);
        if bid_price > a_i'*shadow_price
            if ~(any(b_remaining(a_i==1)==0))
                x(i) = 1;
                b_remaining = b_remaining - a_i;
            end
        end
    end
end

optimal_value = c'*x;

end



function seriesVec = generateSeries(n)
    % This function generates a vector with elements that double each time, 
    % starting from 50 and going up to a maximum value of n.

    % Initialize the series with the first value
    currentValue = 50;
    seriesVec = currentValue;

    % Loop to generate the series
    while currentValue <= n
        % Double the current value
        currentValue = 2 * currentValue;

        % Check if the new value exceeds n
        if currentValue > n
            break;
        end

        % Append the new value to the series
        seriesVec = [seriesVec, currentValue];
    end
end




      



