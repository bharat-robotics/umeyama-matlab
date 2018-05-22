%%
% Find the Rotation matrix R, translation vector t and Scaling factor c 
% that approximate Y = c* R * X + t using least square approximation. 
% This is used to find the mimium error between ground truth and husky 
% visual odometry package results.

% Inputs:
% Ground truth file - Format - timestamp, x, y, z
% Visual package file - Format - timestamp, x, y, z
% start_index - index in ground trith file where visual odometry package 
% is initialized (check lower value) 
%%

%%
% For planar motion , z co-ordinate may  be ignored
% either append 0 for z or leave empty
%
%%

gt_results = 'gt-husky-indoor-ordered.csv';
package_results = 'dso-husky-indoor.txt';

% Ground truth reading from file
GC = textscan(fopen(gt_results),'%f,%f,%f'); %without z
% GC = textscan(fopen(gt_results),'%f,%f,%f,%f'); with z

gt_T = GC{1};
gx = GC{2};
gy = GC{3};
gz = zeros([length(gx),1]);

% gz = GC {4} if z is present


