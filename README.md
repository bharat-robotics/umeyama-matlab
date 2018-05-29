# Umeyama for Matlab

Shinji Umeyama presented in 1991 a quick and simple algorithm [1] to estimate the rotation and translation of a point cloud to match corresponding points. This is very useful for image registration tasks or calibration of two coordinate systems using measurements in boths frames. The paper can be downloaded from Stanford University [2].

## Usage

Example of the full implementation is in **mse.m** file.

### Interpolation
Inputs - Ground truth file, package result file \s
Format - timestamp, x, y, z

Returns set of package coordinates that match the ground truth coordinates in the ground truth time stamp that will be used for point correspondence. The output coordinates are of same size [3xn]  so that two points at same index correspond to each other. 
- **[gt_coords, pkg_coords] = interpolate(gt_file,pkg_files)**

Sometimes visual odometry package take some time to initialize, points in ground truth before package is initialized are ignored. \s
This method assumes that timestamp of ground truth and package coordinates are same. However, they some package may output the timestamp when it is run. In this case, some extra processing may be required to match the time stamps. This matching is not done in the code.

### Umeyama
Simply add the file to your Matlab path and call it using your point sets in format [3xn]. Please note that the point correspondences are based on the order of the two point sets; thus both matrices must have the same dimension. The output is a [3x3] rotation matrix (R), a [3x1] transformation vector (t) and scaling factor (c):
- **[R, t, c] = umeyama_scaled(X, Y)** *Transformation estimation to match points Y to points X*
- **[R, t, c] = umeyama_scaled(X, Y, true)** *Same output, but additional figure will open to plot the result*

### License
Free to use and adapt in any way you like; for official purposes please use MIT license.

## References
[1] Umeyama S. Least-squares estimation of transformation parameters between two point patterns. IEEE Trans Pattern Anal Mach Intell. 1991;13:376-380. doi:10.1109/34.88573.

[2] http://web.stanford.edu/class/cs273/refs/umeyama.pdf
