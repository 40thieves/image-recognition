function speed_test(im_start, im_end)

% Calculate img dimensions
[img_width, img_height] = size(im_start);
img_center_height = img_height / 2;

% Split image into regions
im_start_label = bwlabel(im_start, 4); % Label regions - pass in img, and the number of connected objects returns matrix where L is an image containing the labels, and num is the number of regions
im_end_label = bwlabel(im_end, 4);

% Calculate ConvexArea and Area properties of the regions
start_stats = regionprops(im_start_label, 'Centroid', 'ConvexArea', 'BoundingBox'); % Returns a set of properties (defined by the arguments passed in)
end_stats = regionprops(im_end_label, 'Centroid', 'ConvexArea', 'BoundingBox');

% Find region with largest area, and it's index
[start_max_area, start_max_index] = max([start_stats.ConvexArea]);
[end_max_area, end_largest_index] = max([end_stats.ConvexArea]);

% Calculate the centroid of the region
start_centroids = [start_stats.Centroid];
end_centroids = [end_stats.Centroid];

% Convert largest area index to centroid's index
start_centroid_index = (start_max_index * 2) - 1;
end_centroid_index = (end_largest_index * 2) - 1;

% Get the centroid with the largest area
start_centroid = [start_centroids(start_centroid_index), start_centroids(start_centroid_index + 1)];
end_centroid = [end_centroids(end_centroid_index), end_centroids(end_centroid_index + 1)];

% Calculate the difference in pixels from the center of the image
if (start_centroid(2) < img_center_height)
    % Centroid above center
    start_diff_px = img_center_height - start_centroid(2);
else
    % Centroid below center
    start_diff_px = start_centroid(2) - img_center_height;
end

if (end_centroid(2) < img_center_height)
    % Centroid above center
    end_diff_px = img_center_height - end_centroid(2);
else
    % Centroid below center
    end_diff_px = end_centroid(2) - img_center_height;
end

% Convert the distance in pixels to degree, relative to the center angle 
% (60 deg)
start_diff_deg = 60 - (start_diff_px * 0.042);
end_diff_deg = (end_diff_px * 0.042) + 60;

% Convert distance in degrees to meters
start_diff_m = 7 * tand(start_diff_deg);
end_diff_m = 7 * tand(end_diff_deg);

% Compare to find distance travelled
% Assume that time between first and last image is 1 sec - gives speed in
% m/s
speed_metres = end_diff_m - start_diff_m;

% Convert to mph
speed_miles = speed_metres * 2.24;

disp('Speed in mph is: ')
disp(speed_miles)










