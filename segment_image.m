function im_output = segment_image(im_input)

% Filter image with average filter
filter_av = fspecial('average', 20); % Create average filter
im_gau = imfilter(im_input, filter_av, 'replicate'); % Apply average filter

% Convert image to black and white
im_bw_reversed = im2bw(im_gau, 0.22);

% Reverse the b/w img, so foreground becomes background
im_output = im_bw_reversed < max(im_bw_reversed(:));