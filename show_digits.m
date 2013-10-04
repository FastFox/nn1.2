clear all
load digits

%The training patterns are in the matrix 'training'; their labels are in 'trainingd'.
%We can display all patterns one by one using the following loop:

%figure('Position',[200 200 300 400])
colormap gray %make sure that the image is black and white
%disp('Press Ctrl-C to exit... ') 

%amount = zeros(10, 1);
%total = zeros(10, 1);

center = zeros(10, 256);

% Calculate center. It results in an average digit per digit.
for d = 0:9
	indices_by_digit = find( trainingd == d );
	pixels = training(:, indices_by_digit);
	center(d + 1, :) = mean(pixels, 2);

	% Show average digit, per digit
	if false
		imagesc(reshape(center(d + 1, :), 16, 16)');
	  title(['\bf Digit: ' num2str(d)])
	  pause
	end
end

centerDistances = zeros(10, 10);
for i = 0:9
	for j = 0:9
		centerDistances(i + 1, j + 1) = sum(power(center(i + 1) - center(j + 1), 2));
	end
end

%centerDistances % A lot of distances of 0, which means similar, and so the classifier does not have a high expected accuracy.



% Calculate per image of the training set the distance and compare it with the center of the training set per digit.
distances = zeros(10, 1);
index = 1;
for index = 1:2
	for d = 0:9
		distances(d + 1) = sum(power(training(:, index) - center(d + 1), 2));
		%distances(d + 1) = dist(training(:, index) - center(d + 1)); % Does not work in octave
		%distances(d + 1) = sum(abs(training(:, index) - center(d + 1)));
	end
	[minimum, minimumIndex] = min(distances);
	disp(['Digit is recognized as ' num2str(minimumIndex - 1) '. It should be digit ' num2str(trainingd(index))]);
	%x=reshape(training(:, index), 16, 16)';
	%imagesc(x);
end


% Show all images in de training set.
for i=1:length(training)
    x=training(:,i); %the i-th row


		%amount(trainingd(i) + 1) = amount(trainingd(i) + 1) + 1;
		%total(trainingd(i) + 1) = amount(trainingd(i) + 1) + mean(x);
    %x=reshape(x, 16, 16); %reorganize it into a 16x16 array
    %x=x'; %rotate it
    %imagesc(x); %display the image
    %title(['\bf Digit: ' num2str(trainingd(i))])
    %pause %press anything to continue
end

for i = 1:10
	%amount(i) / total(i)
end
