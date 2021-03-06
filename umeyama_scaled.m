function [ R, t, c ] = umeyama_scaled( X, Y, plotResult )
%UMEYAMA_SCALED Corresponding point set registration with Umeyama method.
%
% [R, t] = umeyama(X, Y)   returns the rotation matrix R and translation
% vector t that approximate Y = c * R * X + t using least-squares estimation. X
% and Y are in format [3xn] and point X(:,i) corresponds to point Y(:,i)
% for all i.
%
% [R, t] = umeyama(X, Y, true)  returns the same result but in addition a
% figure is created plotting the registration result and the average
% registration error.
%
% Author: Bharat Joshi, 2018
% Modified to accomadoate scaling from : Christoph Graumann, 2015

assert(size(X,1)==size(Y,1) && size(X,2)==size(Y,2),'Dimensions of matrices must match!');
assert(size(X,1)==3, 'The points must be given in format [3xn]');

%% Demean
m = size(X,1);
n = size(X,2);
mean_X = mean(X,2);
mean_Y = mean(Y,2);
X_demean = X - repmat(mean_X,1,size(X,2));
Y_demean = Y - repmat(mean_Y,1,size(Y,2));

%% SVD
sigma = 1/n*Y_demean*X_demean';
[U,D,V] = svd(sigma);

%% Define S
S = eye(m);
if det(sigma) < 0 || (rank(sigma) == m-1 && det(U)*det(V) < 0)
    S(m,m) = -1;
end

%% Scaling factor c
sigma_x = mean(sum(X_demean.*X_demean));
c = trace(D*S)/sigma_x;

%% Boot, strap
R = U*S*V';
t = mean_Y - c * ( R * mean_X);

%% Plotting
if nargin>2 && plotResult
    figure('name','Result of Umeyama registration');
    scatter3(X(1,:),X(2,:),X(3,:),'g','*');
    hold on;
    scatter3(Y(1,:),Y(2,:),Y(3,:),'b','o');
    rot = c*R;
    X_prime = [rot t; 0 0 0 1] * [X;ones(1,size(X,2))];
    scatter3(X_prime(1,:),X_prime(2,:),X_prime(3,:),'r','*');
    axis equal tight;
    legend('Source points','Destination points','Transformation result');
    MEAN_REGISTRATION_ERROR = norm(mean(abs(Y - X_prime(1:3,:)),2))
end

end
