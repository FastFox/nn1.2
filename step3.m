clear all
load digits

% Shuffle train and test set
together = [training testdata];
shuffled = together(:, randperm(size(together, 2)));
training = shuffled(:, 1:1707);
testdata = shuffled(:, 1708:size(together, 2));

% Single layer perceptron

n = 1707; % Amount of examples used from the training set. Max 1707
input = training(:, 1:n)';
dim = 256;
iterations = 1000000;

bias = -1;
alpha = 0.5; % Learning rate
beta = 1.0;
rand('state', sum(100 * clock));
weights = randn(dim + 1, 10);%-1 * 2 .* randn(dim + 1, 10);

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
% 	for d = 1:10
		%for e = 1:n
%             y = bias * weights(1, :) + sum(repmat(input(e, :)',1,10) .* weights(2:end, :));  
%             delta = zeros(1,10);
%             delta(trainingd(e)+1) = 1;
%             delta = delta - (y > 0);
% 			weights(1, :) = weights(1, :) + alpha * bias * delta;
%             weights(2:end, :) = weights(2:end, :) + alpha * input(e, :)' * delta;
            %Kies een random element
            e = ceil(rand*n);
            %Bereken de input
            y = bias * weights(1, :) + sum(repmat(input(e, :)',1,10) .* weights(2:end, :));  
            %bereken de delta
            delta = zeros(1,10);
            delta(trainingd(e)+1) = 1;  %Delta moet alleen het goede getal 1 zijn, de rest 1
            delta = delta - (y > 0); 
			weights(1, :) = weights(1, :) + alpha * bias * delta;
            weights(2:end, :) = weights(2:end, :) + alpha * input(e, :)' * delta;            
            if mod(i,5000) == 0
                disp(i/5000)
            end
		%end
% 	end
end
toc()
cm = zeros(10, 10);
out = 0;

if true
% Predict the training set with the training set
for e = 1:n
	for d = 1:10
        y = bias * weights(1, d) + sum(input(e, :)' .* weights(2:end, d));
		if y > 0
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
    	y = bias * weights(1, d) + sum(input(e, :)' .* weights(2:end, d));
		if y > 0
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

end % end if false
