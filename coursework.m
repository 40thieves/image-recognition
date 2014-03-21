clear;

im_start = imread('001.jpg');
im_end = imread('010.jpg');

% Test if object is a fire engine, using red colour
fire_engine_test(im_start)

% Segment images using color sample
im_start_bw = segment_image(im_start, im_end);
im_end_bw = segment_image(im_end, im_start);

% Test first and last images for speed
speed_test(im_start_bw, im_end_bw);

% Test first image for size
oversize_test(im_start_bw);