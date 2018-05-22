function [ground_truth_coords,package_coords] = interpolate(gt_file,pkg_file)
%INTERPOLATE Interpolate to find the package coordinate
%   points at ground truth timestamp


    % Ground truth reading from file
    GC = textscan(fopen(gt_file),'%f,%f,%f'); %without z
    % GC = textscan(fopen(gt_results),'%f,%f,%f,%f'); with z
    gt_T = GC{1};
    gx = GC{2};
    gy = GC{3};
    gz = zeros([length(gx),1]);
    % gz = GC {4} if z is present

    C = textscan(fopen(pkg_file), '%f,%f,%f,%f,%f,%f,%f,%f');
    % my package has time,x,y,z,qx,qy,qz,qw but we just need time,
    pk_T = C{1}; % Time stamps.
    px = C{2}; % Xs
    py = C{3}; % Ys
    pz = zeros([length(px),1]); % Zs 
    % pz = GC {4} if z is present

    first_stamp = pk_T(1);  %first stamp where the visual odometry initailized
    gt_first_index = 1;        %index where the ground truth 
    
    while gt_T(gt_first_index) < first_stamp
        gt_first_index = gt_first_index + 1;
    end

    gt_last_index = size(gt_T,1);   %last index of ground truth
    pkg_last_index = size(pk_T,1);  %pkg last index
    
    n=1;
    
   ground_truth_coords = zeros(3,gt_last_index-gt_first_index+1);
   package_coords =  zeros(3,gt_last_index-gt_first_index+1);
   
    for i=gt_first_index:gt_last_index
        lowerflag=false;
        upperflag=false;
        
        for j=1:pkg_last_index
           if gt_T(i) > pk_T(j)
               lowerflag = true;
               max_lower = j;
           else
               upperflag = true;
               min_upper = j;
               break
           end
        end
        
        if not(upperflag) && lowerflag
            package_coords(:,n) = [px(max_lower),py(max_lower),px(max_lower)];
        elseif not(lowerflag) && upperflag
            package_coords(:,n) = [px(min_upper),py(min_upper),px(min_upper)];
        elseif not(upperflag) && not(lowerflag)
            break % not damn sure!
        else
            interpolation_factor=abs(gt_T(i)-pk_T(max_lower))/abs(pk_T(min_upper)-pk_T(max_lower));
            interpolated_x=interpolation_factor*(px(min_upper)-px(max_lower))+px(max_lower);
            interpolated_y=interpolation_factor*(py(min_upper)-py(max_lower))+py(max_lower);
            interpolated_z=interpolation_factor*(pz(min_upper)-pz(max_lower))+pz(max_lower);
            package_coords(:,n) = [interpolated_x,interpolated_y,interpolated_z];
        end
        ground_truth_coords(:,n) = [gx(i),gy(i),gz(i)];
        n = n+1;
    end
    
end

