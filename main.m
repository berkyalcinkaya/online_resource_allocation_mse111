addpath("solvers/")
addpath("data/")
addpath("metrics/")

% set default plot attributes
set(0,'defaultAxesFontSize',18)


n = 10000; % number of bidders
m = 10; % number of products
inventory = 1000; % set each bi to inventory
price_vector_value = 10; % ground truth price vector value 
[P,A,b,ground_truth_price_vector] = generate_random_resource_data(n,m, price_vector_value, inventory);

[x, fval, exitflag, output, lambda]= linprog(-P,A,b,[],[],zeros(n,1),ones(n,1)); 
optimal_offline_solution = P'*x;

% PROBLEM 1
k_values = 1:500;
k_values_of_interest_indices = [50,100,200];
optimal_values = zeros(length(k_values),1);
avg_profits = zeros(length(k_values),1);

idx = 1;
for k = k_values
    [opt_value, x,~] = onetime_online_learning_solver(A,b,P,k);
    optimal_values(idx) = opt_value;
    [avg_profit ]= get_avg_profit_per_sale(A,ground_truth_price_vector,P,x);
    avg_profits(idx) = avg_profit;
    idx = idx+ 1;
end

% PROBLEM 2
[optimal_value_ml, shadow_prices, k_updates,x_ml] = multitime_online_learning_solver(A,b,P);
num_estimates = length(k_updates);
cos_similarities = zeros(num_estimates,1);
for i=1:num_estimates
    estimated_shadow_price_k = shadow_prices(:,i);
    cos_similarities(i) = cos_sim(estimated_shadow_price_k, ground_truth_price_vector);
end

% PROBLEM 3
[opt_value_ah, x_ah] = AHDLsolver(A,b,P);
diffs_ml = get_online_offline_diffs_per_timepoint(x_ml,P,optimal_offline_solution);
diffs_ah = get_online_offline_diffs_per_timepoint(x_ah,P,optimal_offline_solution);
k_values_diff = 2:n;


% PLOT RESULTS
figure(1)
plot(k_values,optimal_values, "--g", "LineWidth", 1);
xlabel('Shadow Price Learning Period');
ylabel('Optimal Revenue');
title('SLPM Revenue Increases and Stabilizes for a Greater Learning Period');

figure(2)
plot(k_values, optimal_values/optimal_offline_solution, "--g", "LineWidth", 1)
xlabel('Shadow Price Learning Period (K)');
ylabel('SLPM Solution/Offline Solution');
title('SLPM Revenue Approaches Offline Optimal as Learning Period Lengthens');

ratios = optimal_values/optimal_offline_solution;
hold on;
plot(k_values(k_values_of_interest_indices),ratios(k_values_of_interest_indices), '-rs', 'MarkerSize', 10, "LineWidth", 3); % 'rs' -> red square markers
hold off;

figure(3)
plot(k_updates, cos_similarities, "--rs", "LineWidth",2);
xlabel("K");
ylabel('cosine-similarity(ybar_k, pbar)')
title(["Convergence of Estimated Shadow Price"; "to Ground Truth Price as k Increases"]);

figure(4)
p1 = plot(k_values_diff, abs(diffs_ml),"-b");
hold on;
p2 = plot(k_values_diff, abs(diffs_ah),"-r");
hold off;
xlabel("Bid (k)");
ylabel("| online-offline difference metric |");
title(["Comparison of MTOL and AHDL" ; "to Offline Solution at Bid k"]);
legend([p1(1), p2(1)], "MTOL", "AHDL", "Location", "southoutside");


x = ["Offline",  "Action-history", "Multi-time", "SLPM (k=200)", "SLPM (k=100)", "SLPM (k=50)"];
to_add = flip(optimal_values(k_values_of_interest_indices));
y = [optimal_offline_solution opt_value_ah optimal_value_ml to_add(1) to_add(2) to_add(3)];
figure(5);
% Creating the bar graph with manual x-axis values
bar(1:length(x), y);

% Set the x-axis tick labels
set(gca, 'xtick', 1:length(x), 'xticklabel', x);

% Optionally, adjust axis labels and title
xlabel("Algorithm");
ylabel("Optimal Solution");
title("Algorithm Comparison: Revenue");

% Ground truth values
gt = optimal_offline_solution; % Define gt1
percent_error = abs((y - gt) ./ gt) * 100;
figure(6)
bar(1:length(x), percent_error);
set(gca, 'xtick', 1:length(x), 'xticklabel', x);
% Optionally, adjust axis labels and title
xlabel("Algorithm");
ylabel("Optimal Solution");
title("Algorithm Comparison: Percent Error");

% Create a table
T = array2table([y; percent_error]);
writetable(T,"values.csv");









