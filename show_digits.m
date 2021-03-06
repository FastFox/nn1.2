clear all
load digits

%The training patterns are in the matrix 'training'; their labels are in 'trainingd'.
%We can display all patterns one by one using the following loop:

%figure('Position',[200 200 300 400])
%colormap gray %make sure that the image is black and white
%disp('Press Ctrl-C to exit... ') 

%amount = zeros(10, 1);
%total = zeros(10, 1);

if false
	center = zeros(10, 256);
  maxNormDist = zeros(10, 1);
  maxRadius = zeros(10, 1);
  stdss = zeros(10, 1);

	% Calculate features
	for d = 0:9
		indices_by_digit = find( trainingd == d );
		pixels = training(:, indices_by_digit);
       
    % Center
		center(d + 1, :) = mean(pixels, 2);
        
    % Diameter: Dit klopt! (Hopelijk, Waarschijnlijk, Ok, we gaan ervan
    % uit. Waarschijnlijk niet.Eigenlijk klopt er niks van. Het is
    % fout...
    normsDist = zeros(size(pixels, 2), size(pixels, 2));
		size(pixels, 2)
    for i = 1:size(pixels,2)
      for j = i+1:size(pixels,2)
      %for j = 1:size(pixels,2)
     		normsDist(i, j) = norm(pixels(:, i) - pixels(:, j));
				%normDist(i, j) = norm(minus(pixels(:, i), pixels(:, j)));
   		end            
    end
        
		%size(normsDist(:))
		%size(normsDist())
    maxNormDist(d + 1) = max(normsDist(:));
      
    % Radius
    radius = zeros(10, size(pixels,2));
    size(pixels,2);
    for i = 1:size(pixels,2)
 	   radius(d + 1, i) = norm(center(d + 1, :) - pixels(:, i)'); 
    end
        
    maxRadius(d + 1) = max(radius(:));
        
        
    % Std
    stds = zeros(10, size(pixels, 2));
    size(pixels,2);
    for i = 1:size(pixels,2)
  	  stds(d + 1, i) = norm(center(d + 1, :) - pixels(:, i)'); 
    end
        
    %stdss(d + 1) = std(radius(:));
        
    % mean(std(pixels))
        
		target
		% Show average digit, per digit
		if false
			imagesc(reshape(center(d + 1, :), 16, 16)');
			title(['\bf Digit: ' num2str(d)])
			pause
		end
  end % End for every digit
  %stdss
  maxNormDist
 %	maxRadius

	centerDistances = zeros(10, 10);
	for i = 0:9
		for j = 0:9
			if i == j
				centerDistances(i + 1, j + 1) = 0;
			elseif i < j
				centerDistances(i + 1, j + 1) = sum(power(center(i + 1, :) - center(j + 1, :), 2));
				centerDistances(j + 1, i + 1) = centerDistances(i + 1, j + 1);
			end
		end
	end



	avgd = zeros(10, 1); % Average distance per digit (standard deviations)
	for d = 0:9
		avgd(d + 1) = mean(nonzeros(centerDistances(d + 1, :)));
    end
    %avgd

	%centerDistances; % No low distances, so it's actually a pretty good classifier. 
	zdist = zeros(10, 10);
	for i = 0:9
		for j = 0:9
			if i == j
				zdist(i + 1, j + 1) = 0;
			elseif i < j
				%zdist(i + 1, j + 1) = (avgd(i + 1), avgd(j + 1)) / centerDistances(i + 1, j + 1);
				zdist(i + 1, j + 1) = (avgd(i + 1) + avgd(j + 1) ) / centerDistances(i + 1, j + 1);
				zdist(j + 1, i + 1) = zdist(i + 1, j + 1);
			end
		end
	end

	%zdist

	% confusion matrix
	cm = zeros(10, 10); % predicted, actual

	% Calculate per image of the training set the distance (from the center) and compare it with the center of the training set per digit.
	distances = zeros(10, 1);
	index = 1;
	for index = 1:length(training)
		for d = 0:9
			distances(d + 1) = sum(power(training(:, index)' - center(d + 1, :), 2));
		end
		[minimum, minimumIndex] = min(distances);
		cm(minimumIndex, trainingd(index) + 1) = cm(minimumIndex, trainingd(index) + 1) + 1;
	end

	ac = trace(cm) / length(training); % Accuracy for training set
	ac

	% confusion matrix
	cm = zeros(10, 10); % predicted, actual

	% Calculate per image of the test set the distance and compare it with the center of the training set per digit.
	distances = zeros(10, 1);
	index = 1;
	for index = 1:length(testdata)
		for d = 0:9
			distances(d + 1) = sum(power(testdata(:, index)' - center(d + 1, :), 2));
		end
		[minimum, minimumIndex] = min(distances);
		cm(minimumIndex, testdatad(index) + 1) = cm(minimumIndex, testdatad(index) + 1) + 1;
	end

	ac = trace(cm) / length(testdata); % Accuracy for test set
	ac % Lower accuracy compared of the accuray of the training set, as expected.

	cm % The digits 1 and 7 are difficult to classify (as you can imagine), and also a little bit 2 and 8. 

	%for i = 1:10
	%	ac = ac + cm(i, i);
	%end
	%ac = 


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

end % end if false

% Step 3

g = @(y, beta) 1 / (1 + exp(-beta * y));
gprime = @(y, beta) beta * g(y, beta) * (1 - g(y, beta));

%size(trainingd)
%size(training'(1:3, :))
more off; % Outputting information while running

if true
	cm = zeros(10, 10); % predicted, actual
%	input = [0 0 0; 0 0 1;	0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
	%input = training'(1:3, :);
	amount = 3;
  input = training(:, 1:amount)';
  %input = training()';
	numIn = size(input, 1);
	%target = [0; 0; 0; 0; 0; 0; 0; 1];
	%target = trainingd(1:3)
	%target = zeros(3, 1);
	%for i = 1:3
	%	target(i, 1) = 1;
	%end
	%target(1, 1) = 1;

	%target = trainingd()
	%target
	bias = -1;
	alpha = 0.7; % Learning rate
	beta = 1.0;
	rand('state', sum(100 * clock));
	weights = -1 * 2. * rand(size(input, 2) + 1, 10);
	%size(weights)

	%d = 5;
	for d = 1:10
		target = zeros(amount, 10);
		for j = 1:numIn
			if trainingd(j) == d
				target(j, d + 1) = 1;
			end
		end

		%target

		iterations = 100;
		for i = 1:iterations
			if mod(i, 100) == 1
				i;
			end
			out = zeros(numIn, 1);
			for j = 1:numIn
				%y = bias * weights(1, 1) + input(j, 1) * weights(2, 1) + input(j, 2) * weights(3, 1);
				y = bias * weights(1, d);
				for k = 1:size(input, 2)
					y = y + input(j, k) * weights(k + 1, d);
				end
				%y

				%out(j) = y;
				%out(j) = 1 / (1 + exp(-beta * y));
				if 1 / (1 + exp(-beta * y)) > 0.5
					out(j, 1) = 1;
				else
					out(j, 1) = 0;
				end

				delta = target(j, d) - out(j, 1);
				weights(1, d) = weights(1, d) + alpha * bias * delta;
				for k = 1:size(input, 2)
					weights(k + 1, d) = weights(k + 1, d) + alpha * input(j, k) * delta;
				end	
			end
		end
	end


	%trainingd(1:amount)

	% Test with training set
	for l=1:1
  	input = training(:, l)';
		numIn = size(input, 2);

		% Setup target
		target = zeros(10, 1);
		target(trainingd(l)) = 1;
		%for j = 1:10
		%	if trainingd(j) == d
		%		target(j) = 1;
		%	end
		%end

		target
		

		% Calculate output with the weights (which were calculated in the previous step)
		out = zeros(10, 1);
		for j = 1:10
			y = bias * weights(1, d);
			for k = 1:size(input, 2)
				y = y + input(j) * weights(k + 1, d);
			end

			if 1 / (1 + exp(-beta * y)) > 0.5
				out(j, 1) = 1;
			else
				out(j, 1) = 0;
			end
		end

		%out
			
		cm(trainingd(l), d + 1) 	= cm(trainingd(l), d + 1) + isequal(target, out);

		% Compare out with target
		%cm(	
		%target(:, d + 1)
		%out
	end

	%cm


	for i=1:0
				x=training(:,i); %the i-th row


				%amount(trainingd(i) + 1) = amount(trainingd(i) + 1) + 1;
				%total(trainingd(i) + 1) = amount(trainingd(i) + 1) + mean(x);
				x=reshape(x, 16, 16); %reorganize it into a 16x16 array
				x=x'; %rotate it
				imagesc(x); %display the image
				title(['\bf Digit: ' num2str(trainingd(i))])
			pause %press anything to continue
	end
end % end if false
