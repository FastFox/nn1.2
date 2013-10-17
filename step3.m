clear all
load digits

% Shuffle train and test set
together = [training testdata];
shuffled = together(:, randperm(size(together, 2)));
training = shuffled(:, 1:1707);
testdata = shuffled(:, 1708:size(together, 2));

% Single layer perceptron

n = 40; % Amount of examples used from the training set. Max 1707
input = training(:, 1:n)';
dim = 256;
iterations = 20;

bias = -1;
alpha = 0.7; % Learning rate
beta = 1.0;
rand('state', sum(100 * clock));
weights = -1 * 2. * rand(dim + 1, 10);

%target = zeros(n, 10);
%for e = 1:n % for every example from the input set
%	for d = 1:10 % for every digit
%		if trainingd(e) == d - 1
%			target(e, d) = 1;
%		end
%	end
%end


% Calculating weights
tic()
for i = 1:iterations
	for d = 1:10
		for e = 1:n
			y = bias * weights(1, d);
			for j = 1:dim
				y = y + input(e, j) * weights(j + 1, d);
			end
			if 1 / (1 + exp(-beta * y)) > 0.5
				out = 1;
			else
				out = 0;
			end	
	
			delta = (trainingd(e) == d - 1) - out;
			%delta = target(e, d) - out;
			weights(1, d) = weights(1, d) + alpha * bias * delta;
			for j = 1:dim
				weights(j + 1, d) = weights(j + 1, d) + alpha * input(e, j) * delta;
			end			

		end
	end
end
toc()
cm = zeros(10, 10);
out = 0;

% Predict the training set with the training set
for e = 1:n
	for d = 1:10
		y = bias * weights(1, d);
		for j = 1:dim
			y = y + input(e, j) * weights(j + 1, d);
		end
		if 1 / (1 + exp(-beta * y)) > 0.5
			out = 1;
		else
			out = 0;
		end	

		if out == 1
			%if target(e, d) == 1 
			if trainingd(e) == d - 1
				cm(d, d) = cm(d, d) + 1;
			else
				cm(trainingd(e) + 1, d) = cm(trainingd(e) + 1, d) + 1;
			end
		end
	end
end

cm

sum(sum(cm)) % Not exactly the same as n, because some images couldn't be classified and some images are classified double
ac = trace(cm) / n

cm = zeros(10, 10);
% Predict the test set with the training set
input = testdata()';
n = size(input, 1);
for e = 1:n
	for d = 1:10
		y = bias * weights(1, d);
		for j = 1:dim
			y = y + input(e, j) * weights(j + 1, d);
		end
		if 1 / (1 + exp(-beta * y)) > 0.5
			out = 1;
		else
			out = 0;
		end	

		if out == 1
			%if target(e, d) == 1 
			if testdatad(e) == d - 1
				cm(d, d) = cm(d, d) + 1;
			else
				cm(testdatad(e) + 1, d) = cm(testdatad(e) + 1, d) + 1;
			end
		end
	end
end

cm

ac = trace(cm) / n
