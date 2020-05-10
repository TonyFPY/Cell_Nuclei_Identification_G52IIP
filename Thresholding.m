% ----------------------------- Thresholding ------------------------------

% This function passes an image matrix and a string as parameters and
% outputs an image matrix after processing in a corresponding method. The
% image thresholding are implemented in different fashions and please view
% comments of each function to have a good understanding of their
% functionalities.
%
% Author: Pinyuan Feng (scypf1)
% Student ID: 20028407

function img = Thresholding(img, method)
    switch method
        case 'OtsuThresholding'
            img = OtsuThresholding(img);
        case 'IterateThresholding'
            img = IterateThreshlding(img);
        case 'RosinThresholding'
            img = RosinThresholding(img);
        case 'LocalAdaptiveThresholding'
            img = LocalAdaptiveThresholding(img);
    end
end

% This function applies global Otsu thresholding method with the built-in
% function graythresh().
function img = OtsuThresholding(img)
    level = graythresh(img);
    img = imbinarize(img,level);
end

% This function applies global iterated thresholding. We use the average
% pixel value of whole image to initialize the threshold.
function img = IterateThreshlding(img)
    img = im2double(img);   
    % Initialization of the threshold
    T = (min(img(:)) + max(img(:)))/2;
    done = false;
    while ~done
        g = (img >= T);
        Tn = (mean(img(g)) + mean(img(~g)))/2;
        % stop the loop until the difference < the setting value 0.1
        done = (abs(T - Tn) < 0.1);
        T = Tn;
    end
    level = T;
    img = imbinarize(img,level);
end 

% This function applies global Rosin thresholding. The implementation of 
% this function mostly refers to the code from the official MATLAB website,
% because the inner implementation details are out of scope of this
% assignment. The reason that I want to use this method is that I find the
% histogram of the image is unimodal and applying Rosin thresholding may
% have a good effect.
% Reference: https://uk.mathworks.com/matlabcentral/fileexchange/45443-rosin-thresholding
function img = RosinThresholding(img)
    histogram = imhist(img);
    [peak_max, pos_peak] = max(histogram);
    % Highest Point
    p1 = [pos_peak, peak_max];
    ind_nonZero = find(histogram > 0);
    last_zeroBin = ind_nonZero(end);
    % last point
    p2 = [last_zeroBin, histogram(last_zeroBin)];
    best_idx = -1;
    max_dist = -1;
    for x0 = pos_peak:last_zeroBin
        y0 = histogram(x0);
        a = p1 - p2;
        b = [x0,y0] - p2;
        cross_ab = a(1)*b(2) - b(1)*a(2);
        d = norm(cross_ab)/norm(a);
        if(d > max_dist)
            best_idx = x0;
            max_dist = d;
        end
    end
    mean_threshold = best_idx;

    img(img < mean_threshold) = 0;
    img(img > mean_threshold) = 255;
end

% This function applies local thesholding. The image is divided into small
% partitions and for each partition, Otsu thresholding is applied.
function img = LocalAdaptiveThresholding(img)
    originalSize = size(img);  % size of original imag

    numOfPartition = 40;    % number of partitions to be set
    length = originalSize(1);   
    height = originalSize(2);   
    lengthOfPartition = floor(length/numOfPartition);  % length of each partition
    heightOfPartition = floor(height/numOfPartition);  % height of each partition

    % processing each partition
    for k = 1 : numOfPartition
        for n = 1 : numOfPartition

            % partition initialzation (marking the position of the block)
            block = zeros(size(img));    
            x_firstPos = 1 + lengthOfPartition * (n - 1);
            y_firstPos = 1 + heightOfPartition * (k - 1);     
            x = x_firstPos:(x_firstPos + lengthOfPartition - 1);
            y = y_firstPos:(y_firstPos + heightOfPartition - 1); 
            
            % The pixel value of this part are set to 1 and others remain
            % 0. This means pixel with 1 will be processed.
            block(x, y) = 1;                     

            % partiiton extraction
            img = im2double(img);    
            block = block .* img;    % projection
            block = block(x, y);     

            % apply Otsu thresholdiing
            level = graythresh(block);   
            partition = imbinarize(block,level); 

            % integration
            img(x, y) = partition;     
        end
    end
end

