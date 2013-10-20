clear all
load digits

% Shuffle train and test set
together = [training testdata];
shuffled = together(:, randperm(size(together, 2)));
training = shuffled(:, 1:1707);
testdata = shuffled(:, 1708:size(together, 2));


% Single layer perceptron

indexes = (trainingd == 0 | trainingd == 1 | trainingd == 2);
input = training(:, indexes); %1:n ipv indexes
n = size(input,1); % Amount of examples used from the training set. Max 1707
trainingd = trainingd(indexes); %WEGHALEN

num_nodes = 3;
dim = 256;
iterations = 1000;

bias = -1;
alpha = 0.05; % Learning rate
beta = 1.0;
weights = randn(dim + 1, num_nodes);%-1 * 2 .* randn(dim + 1, 10);
weights(1:10,1)

%target = zeros(n, 10);
%for e = 1:n % for every example from the input set
%	for d = 1:10 % for every digit
%		if trainingd(e) == d - 1
%			target(e, d) = 1;
%		end
%	end
%end

deltacounter = zeros(iterations,1);
counter = 0;
% Calculating weights
tic()
for i = 1:iterations
% 	for d = 1:10
		for e = 1:n
%             y = bias * weights(1, :) + sum(repmat(input(e, :)',1,10) .* weights(2:end, :));  
%             delta = zeros(1,10);
%             delta(trainingd(e)+1) = 1;
%             delta = delta - (y > 0);
% 			weights(1, :) = weights(1, :) + alpha * bias * delta;
%             weights(2:end, :) = weights(2:end, :) + alpha * input(e, :)' * delta;
            %Bereken de input
            y = bias * weights(1, :) + sum(repmat(input(:, e),1,num_nodes) .* weights(2:end, :));  
            %bereken de delta
            delta2 = zeros(1,num_nodes);
            delta2(trainingd(e)+1) = 1;  %Delta moet alleen het goede getal 1 zijn, de rest 1
            delta = delta2 - (y > 0);
            counter = counter + sum(abs(delta));
            %[y>0; delta2; delta]
 			weights(1, :) = weights(1, :) + alpha * bias * delta;
            weights(2:end, :) = weights(2:end, :) + alpha * input(:, e) * delta;            
        end
        %disp(i)       
        deltacounter(i) = counter;
        counter = 0;
% 	end
end
toc()
cm = zeros(10, 10);
out = 0;

weights(1:10,1)
plot(deltacounter);

if true
% Predict the training set with the training set
for e = 1:n
	for d = 1:num_nodes
        y = bias * weights(1, d) + sum(input(:, e) .* weights(2:end, d));
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
	for d = 1:num_nodes
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
