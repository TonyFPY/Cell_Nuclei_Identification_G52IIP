% ------------------------ Noise Reduction Methods ------------------------ 
%
% This function passes an image matrix and a string as parameters and
% outputs an image matrix after processing in a corresponding method. The
% nose reduction are implemented with the MATLAB built-in functions.
%
% Author: Pinyuan Feng (scypf1)
% Student ID: 20028407

function img_NR = NoiseReduction(img, method)
    switch method
        case 'meanFiltering'
            img_NR = medfilt2(img);
        case 'gaussianFiltering'
            img_NR = imgaussfilt(img);
        case 'anisotropicDiffusion'
            img_NR = imdiffusefilt(img);
        case 'bilateralFiltering'
            img_NR = imbilatfilt(img);
    end
end
