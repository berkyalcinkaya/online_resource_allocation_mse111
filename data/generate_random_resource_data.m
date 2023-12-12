
%======================================================
%  Function to generate random bids and fixed inventory for the resource
%  allocation problem in project 3
%  
%
%  Protocol for random bid generate:
%  -----------------------------------------------------------------
%   For k=1:num_bids
%       (1) Fix a ground truth price vector  ̄p > 0. 
%       (2) Generate a vector ak whose each entry is 0 or 1, randomly
%       (3) let Pk = pT*ak+(Gauss random variable with mu = 0, var = 0.2)
% -----------------------------------------------------------------------
% 
% Input:
%   num_bids: number of bids to randomly generate
%   num_resources: the number of products on which a bidder places their
%                   bids
%   price_vector_value: the value at which to set the initial price vector
%   inventory: the value which to give all elements of the vector b,
%               indicating the initial amount of each good present
%
% Output:
%       P: randomly generated bid prices (Pi is the amount each bidder is 
%           willing to pay)
%       A: matrix (shape: num_resources x num_bids) with 1's and 0's.
%           A(i,j) idicates whether or not bidder i intends to include item j
%           in their order
%       b: the inventory vector (column vector shape num_resources x 1)
%           whose values are all set to 'inventory' indicating how much of
%           each item are present initially
%       p: ground truth price vector
%
% Protocol described in lecture 3

%======================================================%
function [P,A, b,p] = generate_random_resource_data(num_bids,num_resources, price_vector_value, inventory)

% define variable names
n = num_bids;
m = num_resources;

% inventory vector is created with all values equal to inventory
b = ones(m,1)*inventory;

% initial price vector is set to price_vector_value for all values
p = ones(m,1)*price_vector_value;


A =  zeros(m, n); % template for A
P = zeros(n,1); % template for price vectors

% for each bid
for i=1:n
    ak = randi([0,1], m,1); % random column vector of 1s and 0s
    A(:,i) = ak; % place into A matrix
    P(i) = p'*ak + rand()*sqrt(0.2); % generate a random price for bid i
end
end





