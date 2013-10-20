load digits

%size(training)
%blackPixels = zeros(1, 1707);
blackPixels = zeros(1, 10);
whitePixels = zeros(1, 10);
grayPixels = zeros(1, 10);
height = zeros(1, 10);
width = zeros(1, 10);
color = zeros(1, 10);
amountOfDigits = zeros(1, 10);
colormap gray

for i = 1:1707
	% Extract amount of (black | white | gray) pixels
	black = size(find(training(:, i) == -1), 1);
	white = size(find(training(:, i) == 1), 1);
	gray = 16 * 16 - black - white;

	blackPixels(trainingd(i) + 1) = blackPixels(trainingd(i) + 1) + black;
	whitePixels(trainingd(i) + 1) = blackPixels(trainingd(i) + 1) + white;
	grayPixels(trainingd(i) + 1) = blackPixels(trainingd(i) + 1) + gray;


	% Calculate height
	firstWhitePixelIndex = find(training(:, i) == 1, 1, 'first');
	firstRowWhitePixel = idivide(firstWhitePixelIndex, 16, 'ceil'); 
	lastWhitePixelIndex = find(training(:, i) == 1, 1, 'last');
	lastRowWhitePixel = idivide(lastWhitePixelIndex, 16, 'ceil'); 
	height(trainingd(i) + 1) = height(trainingd(i) + 1) + 1 + (lastRowWhitePixel - firstRowWhitePixel);

	% Calculate width, it's the same as height, but rotated.
	image = rot90(reshape(training(:, i), 16, 16));
	image = image(:);
	firstWhitePixelIndex = find(image == 1, 1, 'first');
	firstRowWhitePixel = idivide(firstWhitePixelIndex, 16, 'ceil'); 
	lastWhitePixelIndex = find(image == 1, 1, 'last');
	lastRowWhitePixel = idivide(lastWhitePixelIndex, 16, 'ceil'); 
	width(trainingd(i) + 1) = width(trainingd(i) + 1) + (lastRowWhitePixel - firstRowWhitePixel);
	
	% Color
	color(trainingd(i) + 1) = color(trainingd(i) + 1) + mean(training(:, i));


	% Counting total amount of digits per class
	amountOfDigits(trainingd(i) + 1) = amountOfDigits(trainingd(i) + 1) + 1;
end

%blackPixels
%amountOfDigits

% Average amount of (black | white | gray) pixels per digit
%blackPixes ./ amountOfDigits
%whitePixels ./ amountOfDigits
%grayPixels ./ amountOfDigits

% Average high per digit
%height ./ amountOfDigits
%width ./ amountOfDigits

% Average color value per digit
color ./ amountOfDigits
