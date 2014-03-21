function speed_test(im_start, im_end)

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

[start_max_area, start_max_index] = max([start_stats.ConvexArea]);
[end_max_area, end_max_index] = max([end_stats.ConvexArea]);

start_bound_box = start_stats(start_max_index).BoundingBox;
end_bound_box = end_stats(end_max_index).BoundingBox;

start_bound_box_pos_x = start_bound_box(1);
start_bound_box_pos_y = start_bound_box(2);
start_bound_box_width = start_bound_box(3);
start_bound_box_height = start_bound_box(4);
end_bound_box_pos_x = end_bound_box(1);
end_bound_box_pos_y = end_bound_box(2);
end_bound_box_width = end_bound_box(3);
end_bound_box_height = end_bound_box(4);

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
% Assume that time between frames is 0.1 sec, therefore giving speed in m/s
distance_travelled = end_distance - start_distance;
speed_meters = distance_travelled * 10;

% Convert m/s to mph
speed_miles = speed_meters * 2.24;

disp('Speed in mph is: ')
disp(speed_miles)










