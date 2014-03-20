function im_output = segment_image(im_input, im_samp)

% Create average filter
filter_av = fspecial('average', 10);

% Test is sample img exists - if not, use LoG filter to segment img. If
% sample img exists, use img subtraction to filter
% To segment img without sample, pass in empty string as second argument
if (strcmp(im_samp, ''))
    % Filter with average filter
    im_gau = imfilter(im_input, filter_av, 'replicate');
    
    % Convert to black & white
    im_bw_reversed = im2bw(im_gau, 0.25);
    im_output = im_bw_reversed < max(im_bw_reversed(:)); % Reverse b/w so foreground becomes background
else
    % Subtract sample img from main img
    im_sub = imsubtract(im_samp, im_input);

    % Filter with average filter - reduces noise
    im_gau = imfilter(im_sub, filter_av, 'replicate');

    % Convert to black & white
    im_output = im2bw(im_gau, 0.3);
end

% figure, imshow(im_output)