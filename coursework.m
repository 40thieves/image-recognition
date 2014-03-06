clear;

im_start = imread('001.jpg');
im_end = imread('010.jpg');

% figure, imshow(im_start)

% Convert image to black and white
filter_av = fspecial('average', 15); % Create average filter
% Start image
im_start_gau = imfilter(im_start, filter_av, 'replicate'); % Apply average filter
im_start_bw_reversed = im2bw(im_start_gau, 0.25); % Convert to b/w
im_start_bw = im_start_bw_reversed < max(im_start_bw_reversed(:)); % Reverse the b/w img, so foreground becomes background
% End image
im_end_gau = imfilter(im_end, filter_av, 'replicate'); % Apply average filter
im_end_bw_reversed = im2bw(im_end_gau, 0.25); % Convert to b/w
im_end_bw = im_end_bw_reversed < max(im_end_bw_reversed(:)); % Reverse the b/w img, so foreground becomes background

% Calculate img dimensions
[start_img_width, start_img_height] = size(im_start_bw);
[end_img_width, end_img_height] = size(im_end_bw);

% Split image into regions
im_start_label = bwlabel(im_start_bw, 4); % Label regions - pass in img, and the number of connected objects returns matrix where L is an image containing the labels, and num is the number of regions
im_end_label = bwlabel(im_end_bw, 4);

% Display regions
% im_start_label_rgb = label2rgb(im_start_label); % Convert labels to RGB image
% figure, imshow(im_start_label_rgb)
% im_end_label_rgb = label2rgb(im_end_label); % Convert labels to RGB image
% figure, imshow(im_end_label_rgb)

% Calculate ConvexArea and Area properties of the regions
start_stats = regionprops(im_start_label, 'Centroid', 'ConvexArea', 'Area', 'BoundingBox'); % Returns a set of properties (defined by the arguments passed in)
end_stats = regionprops(im_end_label, 'Centroid', 'ConvexArea', 'Area', 'BoundingBox'); % Returns a set of properties (defined by the arguments passed in)

% Calculate the max ConvexArea value (i.e. the size - using the ConvexArea 
% property - of the largest region)
start_areas = [start_stats.ConvexArea];
[start_largest, start_largest_index] = max(start_areas);
end_areas = [end_stats.ConvexArea];
[end_largest, end_largest_index] = max(end_areas);

% Calculate the centroid of the region
start_centroids = [start_stats.Centroid];
end_centroids = [end_stats.Centroid];

% Convert largest area index to centroid's index
start_largest_index = (start_largest_index * 2) - 1;
end_largest_index = (end_largest_index * 2) - 1;

% Get the centroid with the largest area
start_centroid = [start_centroids(start_largest_index), start_centroids(start_largest_index + 1)];
end_centroid = [end_centroids(end_largest_index), end_centroids(end_largest_index + 1)];

% % Calculate the max width of the BoundingBox
% [start_bound_boxes_pos, start_bound_boxes] = start_stats.BoundingBox; % Returns the positions and the size of the bounding boxes
% start_bound_width = max(start_bound_boxes); % Gets the largest bounding box
% [end_bound_boxes_pos, end_bound_boxes] = end_stats.BoundingBox;
% end_bound_width = max(end_bound_boxes);
% 
% % Convert pixel numbers to meters
% start_bound_width_meters = start_bound_width / 101.6;
% end_bound_width_meters = end_bound_width / 101.6;
% 
% diff = start_bound_width_meters - end_bound_width_meters;
% disp(diff);







