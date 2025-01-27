% Define output folder
outputFolder = fullfile(pwd, 'output_images');
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Load and process images
imageFiles = {'image2.png'};

for i = 1:length(imageFiles)
    img = imread(imageFiles{i});
    
    % Convert to grayscale if necessary
    if size(img, 3) == 3
        grayImg = rgb2gray(img); % Convert RGB to grayscale
    else
        grayImg = img;
    end
    
    % FFT and amplitude spectrum
    fftImg = fftshift(fft2(double(grayImg)));
    amplitudeImg = log(1 + abs(fftImg)); % Log scale for better visualization
    
    % Normalize amplitude for saving
    amplitudeImg = uint8(255 * mat2gray(amplitudeImg));
    outputFile = fullfile(outputFolder, ['freq_' imageFiles{i}]);
    imwrite(amplitudeImg, outputFile);
    
    % Filter design
    [m, n] = size(grayImg);
    [x, y] = meshgrid(-n/2:n/2-1, -m/2:m/2-1);
    d = sqrt(x.^2 + y.^2); % Distance from the center
            % Gaussian Low-Pass Filter for image2.png
            filterSize = 15; % Adjust filter size for cutoff frequency
            filterMask = exp(-(d.^2) / (50 * filterSize^2));
    
    % Apply filter in the frequency domain
    filteredFFT = fftImg .* filterMask;
    
    % Inverse FFT to transform back to spatial domain
    filteredImage = abs(ifft2(ifftshift(filteredFFT)));
    filteredImage = uint8(255 * mat2gray(filteredImage)); % Normalize for visualization
    
    % Save filtered image
    filteredFile = fullfile(outputFolder, ['filtered_' imageFiles{i}]);
    imwrite(filteredImage, filteredFile);
    
    % Show results
    figure;
    subplot(1, 3, 1); imshow(grayImg, []); title('Original Image');
    subplot(1, 3, 2); imshow(amplitudeImg, []); title('Frequency Spectrum');
    %subplot(1, 4, 3); imshow(log(1 + abs(filterMask)), []); title([filterType, ' Mask']);
    subplot(1, 3, 3); imshow(filteredImage, []); title('Filtered Image');
end
