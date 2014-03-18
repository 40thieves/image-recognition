clear;

im_input = imread('oversize.jpg');

% Filter image with average filter
filter_av = fspecial('average', 20); % Create average filter
im_gau = imfilter(im_input, filter_av, 'replicate'); % Apply average filter

% Convert image to black and white
im_bw_reversed = im2bw(im_gau, 0.22);

% Reverse the b/w img, so foreground becomes background
image = im_bw_reversed < max(im_bw_reversed(:));

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
















