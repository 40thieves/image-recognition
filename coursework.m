clear;

disp('--- Testing blue car images ---')

im_start_car = imread('001.jpg');
im_end_car = imread('005.jpg');

% Test if image contains a fire engine, using red color and width-to-height
% ratio
fire_engine_test(im_start_car);

% Segment images, using img subtraction
im_start_car_bw = segment_image(im_start_car, im_end_car);
im_end_car_bw = segment_image(im_end_car, im_start_car);

% Test for speed
speed_test(im_start_car_bw, im_end_car_bw);

% Test for size
oversize_test(im_start_car_bw);

disp('--- Testing fire engine images ---')

im_start_fire = imread('fire01.jpg');
im_end_fire = imread('fire02.jpg');

% Test if image contains a fire engine, using red color and width-to-height
% ratio
fire_engine_test(im_start_fire);

% Segment images, using img subtraction
im_start_fire_bw = segment_image(im_start_fire, im_end_fire);
im_end_fire_bw = segment_image(im_end_fire, im_start_fire);

% Test for speed
speed_test(im_start_fire_bw, im_end_fire_bw);

% Test for size
oversize_test(im_start_fire_bw);

disp('--- Testing oversize image ---')

im_oversize = imread('oversize.jpg');

% Test if image contains a fire engine, using red color and width-to-height
% ratio
fire_engine_test(im_oversize);

% Segment image, without using img subtraction
im_oversize_bw = segment_image(im_oversize, '');

% Test for size
oversize_test(im_oversize_bw);





