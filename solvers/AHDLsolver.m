function [opt_value, x] = AHDLsolver(A,b,c)
[~,n] = size(A);
x = zeros(n,1); 
b_remaining = b;
shadow_price = get_shadow_price(A,b,c,1,n);
for i=2:n
    i
    bid_price = c(i);
    a_i = A(:,i);
    if bid_price > a_i'*shadow_price && (all(b_remaining(a_i==1)>0))
            x(i) = 1;
            b_remaining = b_remaining - a_i;
    end
    if (i~=n)
        shadow_price = get_shadow_price(A,b_remaining,c,i, n-i);
    end
end

opt_value = c'*x;

end






