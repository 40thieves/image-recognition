function coursework_func(im_path_1, im_path_2)

im_1 = imread(im_path_1);

% Test if image contains a fire engine, using red color and width-to-height
% ratio
fire_engine_test(im_1);

% Test if second img exists
% If second img exists, segment both images using subtraction and perform speed test
% If second img doesn't exist - i.e. an empty string - only segment image 
if (strcmp(im_path_2, ''))
    % Segment image - without using img subtraction
    im_1_bw = segment_image(im_1, '');
else
    im_2 = imread(im_path_2);
    
    % Segment images - using img subtraction
    im_1_bw = segment_image(im_1, im_2);
    im_2_bw = segment_image(im_2, im_1);
    
    % Test for speed
    speed_test(im_1_bw, im_2_bw);
end

% Test for size
oversize_test(im_1_bw);