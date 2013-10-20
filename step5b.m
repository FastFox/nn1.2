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

% training set
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

% test set
input2 = zeros(6, 1000);

target2 = zeros(100, 10);
for i = 1:1000
	target2(i, testdatad(i) + 1) = 1;
end

for i = 1:1000
	% Extract amount of (black | white | gray) pixels
	input2(1, i) = size(find(testdata(:, i) == -1), 1);
	input2(2, i) = size(find(testdata(:, i) == 1), 1);
	input2(3, i) = 16 * 16 - input2(1, i) - input2(2, i);

	% Calculate height
	firstWhitePixelIndex = find(testdata(:, i) == 1, 1, 'first');
	%firstWhitePixelIndex
	%class(int8(firstWhitePixelIndex))
	%isinteger(firstWhitePixelIndex)
	%isinteger(25)
	%class(25)

	firstRowWhitePixel = idivide(int8(firstWhitePixelIndex), 16, 'ceil'); 
	lastWhitePixelIndex = find(testdata(:, i) == 1, 1, 'last');
	lastRowWhitePixel = idivide(int8(lastWhitePixelIndex), 16, 'ceil'); 
	input2(4, i) = 1 + (lastRowWhitePixel - firstRowWhitePixel);

	% Calculate width, it's the same as height, but rotated.
	image = rot90(reshape(testdata(:, i), 16, 16));
	image = image(:);
	firstWhitePixelIndex = find(image == 1, 1, 'first');
	firstRowWhitePixel = idivide(int8(firstWhitePixelIndex), 16, 'ceil'); 
	lastWhitePixelIndex = find(image == 1, 1, 'last');
	lastRowWhitePixel = idivide(int8(lastWhitePixelIndex), 16, 'ceil'); 
	input2(5, i) = 1 + (lastRowWhitePixel - firstRowWhitePixel);
	
	% Color
	input2(6, i) = mean(testdata(:, i));
end

%input(:, 1:5)

size(input)
size(trainingd)
output = zeros(size(trainingd,2),10);

input = [input; training]; 
input2 = [input2; testdata] %hetzelfde als hierboven, maar nu met input van testset met testset erachter

for d=1:10
    for j = 1:size(target,1)
        if trainingd(j) == d-1
            target(j, d) = 1;
        end
    end         
    net = glm(262, 1, func);%262 = 256 + 6 nieuwe
    net = glmtrain(net, options, input', target(:, d));
    output(:,d) = glmfwd(net, input');  %hier moet input van testset in ipv trainset (dus input2 van hierboven)
    for e=1:1707
        if round(output(e,d))==1 && trainingd(e)==d-1
            cm(d,d) = cm(d,d) + 1;
        else
            cm(trainingd(e)+1,d) = cm(trainingd(e)+1,d);
        end
    end          
end
cm

% test set
for d=1:10
    for j = 1:size(target,1)
        if trainingd(j) == d-1
            target(j, d) = 1;
        end
    end         
    net = glm(262, 1, func);%262 = 256 + 6 nieuwe
    net = glmtrain(net, options, input2', target2(:, d));
    output(:,d) = glmfwd(net, input2');  %hier moet input van testset in ipv trainset (dus input2 van hierboven)
    for e=1:1707
        if round(output(e,d))==1 && trainingd(e)==d-1
            cm(d,d) = cm(d,d) + 1;
        else
            cm(trainingd(e)+1,d) = cm(trainingd(e)+1,d);
        end
    end          
end
cm
