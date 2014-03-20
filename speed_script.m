clear;

im_start_input = imread('001.jpg');
im_end_input = imread('010.jpg');

% Subtract sample img from main img
im_sub_start = imsubtract(im_end_input, im_start_input);
im_sub_end = imsubtract(im_start_input, im_end_input);

% Create average filter
filter_av = fspecial('average', 10);
% Filter with average filter - reduces noise
im_gau_start = imfilter(im_sub_start, filter_av, 'replicate');
im_gau_end = imfilter(im_sub_end, filter_av, 'replicate');

% Convert to black & white
im_start = im2bw(im_gau_start, 0.3);
im_end = im2bw(im_gau_end, 0.3);

% Calculate img dimensions
[img_height, img_width] = size(im_start);
img_center_x = img_width / 2;
img_center_y = img_height / 2;

% Split image into regions
% Label regions - pass in img, and the number of connected objects returns 
% matrix where L is an image containing the labels, and num is the number of regions
im_start_label = bwlabel(im_start, 4);
im_end_label = bwlabel(im_end, 4);

% Calculate ConvexArea and Area properties of the regions
start_stats = regionprops(im_start_label, 'Centroid', 'ConvexArea', 'BoundingBox'); % Returns a set of properties (defined by the arguments passed in)
end_stats = regionprops(im_end_label, 'Centroid', 'ConvexArea', 'BoundingBox');

% Get bounding boxes from labelled regions
start_bound_boxes = [start_stats.BoundingBox];
end_bound_boxes = [end_stats.BoundingBox];

% Loop through each region's bounding box to separate the position of the
% box and it's height and width
start_bound_boxes_pos_x = [];
start_bound_boxes_pos_y = [];
start_bound_boxes_width = [];
start_bound_boxes_height = [];
end_bound_boxes_pos_x = [];
end_bound_boxes_pos_y = [];
end_bound_boxes_width = [];
end_bound_boxes_height = [];

% The BoundingBox contains values in the following order: upper left
% position for x, upper left position for y, width, height
for k = 1:4:length(start_bound_boxes)
    start_bound_boxes_pos_x = [start_bound_boxes_pos_x, start_bound_boxes(k)]; % Separate upper left position for x into it's own array
    start_bound_boxes_pos_y = [start_bound_boxes_pos_y, start_bound_boxes(k + 1)];
    start_bound_boxes_width = [start_bound_boxes_width, start_bound_boxes(k + 2)];
    start_bound_boxes_height = [start_bound_boxes_height, start_bound_boxes(k + 3)];
end

for l = 1:4:length(end_bound_boxes)
    end_bound_boxes_pos_x = [end_bound_boxes_pos_x, end_bound_boxes(l)];
    end_bound_boxes_pos_y = [end_bound_boxes_pos_y, end_bound_boxes(l + 1)];
    end_bound_boxes_width = [end_bound_boxes_width, end_bound_boxes(l + 2)];
    end_bound_boxes_height = [end_bound_boxes_height, end_bound_boxes(l + 3)];
end

% Find the largest region (by width), and get it's index within the array
[start_bound_box_width, start_bound_box_index] = max(start_bound_boxes_width);
[end_bound_box_width, end_bound_box_index] = max(end_bound_boxes_width);

% Find the height, x and y positions of the largest region
start_bound_box_height = start_bound_boxes_height(start_bound_box_index);
start_bound_box_pos_x = start_bound_boxes_pos_x(start_bound_box_index);
start_bound_box_pos_y = start_bound_boxes_pos_y(start_bound_box_index);

end_bound_box_height = end_bound_boxes_height(end_bound_box_index);
end_bound_box_pos_x = end_bound_boxes_pos_x(end_bound_box_index);
end_bound_box_pos_y = end_bound_boxes_pos_y(end_bound_box_index);

% Calculate the centre of the bounding box
start_centroid_x = start_bound_box_pos_x + (start_bound_box_width / 2);
start_centroid_y = start_bound_box_pos_y + (start_bound_box_height / 2);

end_centroid_x = end_bound_box_pos_x + (end_bound_box_width / 2);
end_centroid_y = end_bound_box_pos_y + (end_bound_box_width / 2);

% Calculate the difference (in pixels) between the centre of the image and
% the centre of the bounding box
start_diff_px = img_center_y - start_centroid_y;
end_diff_px = img_center_y - end_centroid_y;

% Convert the difference in pixels to difference in degrees and add to
% degrees from vertical (60)
start_diff_deg = 60 + (start_diff_px * 0.042);
end_diff_deg = 60 + (end_diff_px * 0.042);

% Calculate the (horizontal) distance between the camera and the object
start_distance = 7 * tand(start_diff_deg);
end_distance = 7 * tand(end_diff_deg);

% Compare distance travelled by first and last objects
% Assume that time between frames is 1 sec, therefore giving speed in m/s
speed_meters = end_distance - start_distance;

% Convert m/s to mph
speed_miles = speed_meters * 2.24;

disp('Speed in mph is: ')
disp(speed_miles)