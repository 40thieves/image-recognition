clear;

im_start = imread('001.jpg');
im_end = imread('010.jpg');

% Segment images using color sample
im_start_bw = segment_image(im_start);
im_end_bw = segment_image(im_end);

% Test first and last images for speed
speed_test(im_start_bw, im_end_bw);

% Test first image for size
oversize_test(im_start_bw);