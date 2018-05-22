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

[gt_coords,pkg_coords] = interpolate(gt_results,package_results);

[R_res, t_res, c] = umeyama_scaled(pkg_coords,gt_coords,true);