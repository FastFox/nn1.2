load digits

% Initialize the 6 features 
blackPixels = zeros(1, 10);
whitePixels = zeros(1, 10);
grayPixels = zeros(1, 10);
height = zeros(1, 10);
width = zeros(1, 10);
color = zeros(1, 10);
amountOfDigits = zeros(1, 10);

% Calculating the average of the 6 features for every digit.
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

% Average amount of (black | white | gray) pixels per digit
avgBlack = blackPixels ./ amountOfDigits;
avgWhite = whitePixels ./ amountOfDigits;
avgGray = grayPixels ./ amountOfDigits;

% Average high per digit
avgHeight = height ./ amountOfDigits;
avgWidth = width ./ amountOfDigits;

% Average color value per digit
avgColor = color ./ amountOfDigits;

% Calculate per feature the accuracy and the confusion matrix with the test test
cm = zeros(10, 10); % predicted, actual
distances = zeros(10, 1);

% Black
disp('Black');
cm = zeros(10, 10);
for i = 1:1000
	black = size(find(testdata(:, i) == -1), 1);
	for d = 1:10
		distances(d)	= power(avgBlack(d) - black, 2);
	end
	[minimum, minimumIndex] = min(distances);
	cm(minimumIndex, testdatad(i) + 1) = cm(minimumIndex, testdatad(i) + 1) + 1;
end

cm
ac = trace(cm) / length(testdata)

% White
disp('White');
cm = zeros(10, 10);
for i = 1:1000
	white = size(find(testdata(:, i) == 1), 1);
	for d = 1:10
		distances(d)	= power(avgWhite(d) - white, 2);
	end
	[minimum, minimumIndex] = min(distances);
	cm(minimumIndex, testdatad(i) + 1) = cm(minimumIndex, testdatad(i) + 1) + 1;
end

cm
ac = trace(cm) / length(testdata)

% Gray
disp('Gray');
cm = zeros(10, 10);
for i = 1:1000
	gray = size(find(testdata(:, i) != 1 & testdata(:, 1) != -1), 1);
	for d = 1:10
		distances(d)	= power(avgGray(d) - gray, 2);
	end
	[minimum, minimumIndex] = min(distances);
	cm(minimumIndex, testdatad(i) + 1) = cm(minimumIndex, testdatad(i) + 1) + 1;
end

cm
ac = trace(cm) / length(testdata)

% Height
disp('Height');
cm = zeros(10, 10);
for i = 1:1000
	firstWhitePixelIndex = find(testdata(:, i) == 1, 1, 'first');
	firstRowWhitePixel = idivide(firstWhitePixelIndex, 16, 'ceil'); 
	lastWhitePixelIndex = find(testdata(:, i) == 1, 1, 'last');
	lastRowWhitePixel = idivide(lastWhitePixelIndex, 16, 'ceil'); 
	height = 1 + (lastRowWhitePixel - firstRowWhitePixel);
	for d = 1:10
		distances(d) = power(avgHeight(d) - height, 2);
	end
	[minimum, minimumIndex] = min(distances);
	cm(minimumIndex, testdatad(i) + 1) = cm(minimumIndex, testdatad(i) + 1) + 1;
end

cm
ac = trace(cm) / length(testdata)

% Width
disp('Width');
cm = zeros(10, 10);
for i = 1:1000
	image = rot90(reshape(testdata(:, i), 16, 16));
	image = image(:);
	firstWhitePixelIndex = find(image == 1, 1, 'first');
	firstRowWhitePixel = idivide(firstWhitePixelIndex, 16, 'ceil'); 
	lastWhitePixelIndex = find(image == 1, 1, 'last');
	lastRowWhitePixel = idivide(lastWhitePixelIndex, 16, 'ceil'); 
	width = 1 + (lastRowWhitePixel - firstRowWhitePixel);
	for d = 1:10
		distances(d) = power(avgWidth(d) - width, 2);
	end
	[minimum, minimumIndex] = min(distances);
	cm(minimumIndex, testdatad(i) + 1) = cm(minimumIndex, testdatad(i) + 1) + 1;
end

cm
ac = trace(cm) / length(testdata)

% Color
disp('Color');
cm = zeros(10, 10);
for i = 1:1000
	color = mean(testdata(:, i));
	for d = 1:10
		distances(d)	= power(avgColor(d) - color, 2);
	end
	[minimum, minimumIndex] = min(distances);
	cm(minimumIndex, testdatad(i) + 1) = cm(minimumIndex, testdatad(i) + 1) + 1;
end

cm
ac = trace(cm) / length(testdata)
