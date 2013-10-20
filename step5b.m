load digits

target = zeros(1707, 10);
for i = 1:1707
	target(i, trainingd(i) + 1) = 1;
end

func = 'linear';
options = foptions;
options(1) = 1;
options(14)= 10;

cm = zeros(10, 10);
%for i = 1:1707

input = zeros(6, 1707);

for i = 1:1707
	% Extract amount of (black | white | gray) pixels
	input(1, i) = size(find(training(:, i) == -1), 1);
	input(2, i) = size(find(training(:, i) == 1), 1);
	input(3, i) = 16 * 16 - input(1, i) - input(2, i);

	% Calculate height
	firstWhitePixelIndex = find(training(:, i) == 1, 1, 'first');
	%firstWhitePixelIndex
	%class(int8(firstWhitePixelIndex))
	%isinteger(firstWhitePixelIndex)
	%isinteger(25)
	%class(25)

	firstRowWhitePixel = idivide(int8(firstWhitePixelIndex), 16, 'ceil'); 
	lastWhitePixelIndex = find(training(:, i) == 1, 1, 'last');
	lastRowWhitePixel = idivide(int8(lastWhitePixelIndex), 16, 'ceil'); 
	input(4, i) = 1 + (lastRowWhitePixel - firstRowWhitePixel);

	% Calculate width, it's the same as height, but rotated.
	image = rot90(reshape(training(:, i), 16, 16));
	image = image(:);
	firstWhitePixelIndex = find(image == 1, 1, 'first');
	firstRowWhitePixel = idivide(int8(firstWhitePixelIndex), 16, 'ceil'); 
	lastWhitePixelIndex = find(image == 1, 1, 'last');
	lastRowWhitePixel = idivide(int8(lastWhitePixelIndex), 16, 'ceil'); 
	input(5, i) = 1 + (lastRowWhitePixel - firstRowWhitePixel);
	
	% Color
	input(6, i) = mean(training(:, i));
end

%input(:, 1:5)

size(input)
size(trainingd)

net = glm(6, 1, func);
%net = glmtrain(net, options, input', trainingd);
net = glmtrain(net, options, input', target(1, :));
%output(:,d) = glmfwd(net, training');
