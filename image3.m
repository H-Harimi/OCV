% Load and preprocess the noisy image
image = imread('image3.png'); % Replace with your noisy image file
grayImage = im2double(image); % Normalize the image to range [0, 1]

% Compute the FFT of the image
fftImage = fft2(grayImage); % Perform FFT
fftShifted = fftshift(fftImage); % Shift zero frequency to the center
magnitudeSpectrum = log(abs(fftShifted) + 10); % Magnitude spectrum visualization

% Define image dimensions and center
[m, n] = size(grayImage);
centerX = round(m / 2);
centerY = round(n / 2);

% Create a low-frequency mask to protect essential image details
lowFreqMask = zeros(size(grayImage));
radius = 20; % Radius for low-frequency exclusion
for i = 1:m
    for j = 1:n
        distance = sqrt((i - centerX)^2 + (j - centerY)^2);
        if distance < radius
            lowFreqMask(i, j) = 1;
        end
    end
end

% Gaussian Star Filter Design
[x, y] = meshgrid(1:n, 1:m);
distanceMatrix = sqrt((x - centerX).^2 + (y - centerY).^2);

% Gaussian mask for noise peaks
sigma = 50; % Standard deviation for Gaussian profile
gaussianMask = exp(-distanceMatrix.^2 / (2 * sigma^2)); % Gaussian filter formula

% Combine Gaussian mask with the low-frequency mask
finalMask = 1 - gaussianMask .* (1 - lowFreqMask); 

% Apply the filter mask (element-wise multiplication in frequency domain)
filteredFFT = fftShifted .* finalMask;

% Transform back to the spatial domain
filteredImage = ifft2(ifftshift(filteredFFT)); % Inverse FFT
filteredImage = abs(filteredImage); % Convert to real values

% Visualize results in subplots
figure;

% Original Noisy Image
subplot(1, 3, 1);
imshow(grayImage, []);
title('Original Noisy Image');

% Frequency Spectrum
subplot(1, 3, 2);
imshow(magnitudeSpectrum, []);
title('Frequency Spectrum');

% Filtered Image
subplot(1, 3, 3);
imshow(filteredImage, []);
title('Filtered Image (Noise Removed)');
