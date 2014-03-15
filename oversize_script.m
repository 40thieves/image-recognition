clear;

im_input = imread('oversize.jpg');

% Select a region interest (ROI) interactively
mask = roipoly(im_input);
figure, close all

% Retrieve the red, green, blue components of the pixels inside ROI
red = immultiply(mask, im_input(:,:,1));
green = immultiply(mask, im_input(:,:,2));
blue = immultiply(mask, im_input(:,:,3));

% Assemble the RGB components to restore the image in the ROI (image g)
im_color_sample = cat(3, red, green, blue);

% Pre-processing for calculating the covariance matrix
[img_rows, img_columns, color] = size(im_color_sample); % M-rows, N-columns and K-colour components

% Function reshape re-organises the sample image into a M * N-row by 3
% column array, i.e., each row is the rgb values of a pixel
img_matrix = reshape(im_color_sample, img_rows * img_columns, 3);

% Find the row indices of non-zero pixels of the mask
row_indices = find(mask);

% Use the indices to remove the zero components in I
img_matrix = double(img_matrix(row_indices, 1:3));

% Compute covariance matrix C and the mean m of the samples
[covariant, mean] = covmatrix(img_matrix);

image = colorseg('euclidean', im_input, 90, mean);

% Calculate img dimensions
[img_height, img_width] = size(image);
img_center_x = img_width / 2;
img_center_y = img_height / 2;

im_label = bwlabel(image, 4);

% Get bounding box width
% Returns a set of properties (defined by the arguments passed in)
stats = regionprops(im_label, 'Centroid', 'ConvexArea', 'BoundingBox');

% Get bounding boxes from labelled regions
bound_boxes = [stats.BoundingBox];

% Loop through each region's bounding box to separate the position of the
% box and it's height and width
bound_boxes_pos_x = []; % Creates emtpy arrays for each value
bound_boxes_pos_y = [];
bound_boxes_width = [];
bound_boxes_height = [];
% The BoundingBox contains values in the following order: upper left
% position for x, upper left position for y, width, height
for k = 1:4:length(bound_boxes)
    bound_boxes_pos_x = [bound_boxes_pos_x, bound_boxes(k)]; % Separate upper left position for x into it's own array
    bound_boxes_pos_y = [bound_boxes_pos_y, bound_boxes(k + 1)];
    bound_boxes_width = [bound_boxes_width, bound_boxes(k + 2)];
    bound_boxes_height = [bound_boxes_height, bound_boxes(k + 3)];
end

% Find the largest region (by width), and get it's index within the array
[bound_box_width, bound_box_index] = max(bound_boxes_width);

% Find the height, x and y positions for the largest regions
bound_box_height = bound_boxes_height(bound_box_index);
bound_box_pos_x = bound_boxes_pos_x(bound_box_index);
bound_box_pos_y = bound_boxes_pos_y(bound_box_index);

% Calculate the centre of the bounding box
centroid_x = bound_box_pos_x + (bound_box_width / 2);
centroid_y = bound_box_pos_y + (bound_box_height / 2);

% Calculate the difference (in pixels) between the centre of the image and
% the centre of bounding box
diff_px = img_center_y - centroid_y;

% Convert the difference in pixels to difference in degrees and add to
% degrees from vertical (60)
diff_deg = 60 + (diff_px * 0.042);

% Calculate the (horizontal) distance between the camera and object
distance = 7 * tand(diff_deg);

% Calculate the width of the bounding box in degrees
width_deg = bound_box_width * 0.042;

% Calculate the width of the bounding box in meters
width_m = 2 * (distance * sind(width_deg));

disp('Width in metres: ')
disp(width_m)
















