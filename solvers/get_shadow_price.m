function new_shadow_price = get_shadow_price(A,b,c,k,n)
    Ak = A(:,1:k);
    bk = (k/n)*b;
    ck = c(1:k);
    options = optimoptions('linprog','Algorithm','interior-point');
    [~, ~, ~, ~, lambda]= linprog(-ck,Ak,bk,[],[],zeros(k,1),ones(k,1), options); 
    new_shadow_price = lambda.ineqlin;
