function diffs = get_online_offline_diffs_per_timepoint(x,P,opt)
n = length(x);
diffs = zeros(n-1,1);
for k=2:n
    diffs(k-1) = (P(1:k)'*x(1:k)) - (k/n)*opt;
end

