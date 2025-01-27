% MATLAB script for displaying Original, Frequency Spectrum, and Filtered Images using subplot

% Step 1: Read the image
image = imread('image1.png'); % Replace with your image
%grayscale_image = rgb2gray(original_image); % Convert to grayscale if RGB

% Step 2: Perform Fourier Transform
F = fft2(double(image)); % 2D Fourier Transform
F_shifted = fftshift(F); % Shift zero frequency to center
magnitude_spectrum = log(1 + abs(F_shifted)); % Spectrum visualization

% Step 3: Design Filters
[M, N] = size(image); % Image dimensions
centerX = round(M/2);
centerY = round(N/2);

% 3.a Low-Pass Filter (Preserve Low Frequencies)
D0_low = 50; % Cutoff radius for low frequencies
low_pass_filter = zeros(M, N);
for i = 1:M
    for j = 1:N
        distance = sqrt((i-centerX)^2 + (j-centerY)^2);
        if distance <= D0_low
            low_pass_filter(i, j) = 1;
        end
    end
end

% 3.b High-Pass Filter (Preserve High Frequencies)
D0_high = 30; % Cutoff radius for high frequencies
high_pass_filter = ones(M, N);
for i = 1:M
    for j = 1:N
        distance = sqrt((i-centerX)^2 + (j-centerY)^2);
        if distance <= D0_high
            high_pass_filter(i, j) = 0;
        end
    end
end

% Step 4: Apply Filters in Frequency Domain
% Low-Pass Filtering
F_low_pass = F_shifted .* low_pass_filter;
F_low_pass_shifted = ifftshift(F_low_pass); % Shift back
low_pass_result = real(ifft2(F_low_pass_shifted)); % Inverse Fourier Transform

% High-Pass Filtering
F_high_pass = F_shifted .* high_pass_filter;
F_high_pass_shifted = ifftshift(F_high_pass); % Shift back
high_pass_result = real(ifft2(F_high_pass_shifted)); % Inverse Fourier Transform

% Step 5: Display Results in One Figure using Subplot
figure;

% Original Image
subplot(1, 3, 1);
imshow(image, []);
title('Original Image');

% Frequency Spectrum
subplot(1, 3, 2);
imshow(magnitude_spectrum, []);
title('Frequency Spectrum');

%  Filtered Image
subplot(1, 3, 3);
imshow(uint8(low_pass_result));
title('Filtered Image');


