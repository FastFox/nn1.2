clear all
load digits

% Single layer perceptron
n = 1707; % Amount of examples used from the training set. Max 1707
input = training(:, 1:n); %1:n ipv indexes

num_nodes = 10;
dim = 256;
iterations = 100;

bias = 1;
alpha = 0.7; % Learning rate
beta = 1.0;
weights = randn(dim + 1, num_nodes)*10; %-1 * 2 .* randn(dim + 1, 10);
weights(1:10,1)

deltacounter = zeros(iterations,1);
counter = 0;
% Calculating weights
tic()
for i = 1:iterations
 	for d = 1:num_nodes
		for e = 1:n
    	y = bias * weights(1, d) + sum(input(:, e) .* weights(2:end, d));
      delta = (trainingd(e)==d-1) - (y > 0);
      [trainingd(e) (trainingd(e)==d-1)];
      counter = counter + sum(abs(delta));
 			weights(1, d) = weights(1, d) + alpha * bias * delta;
      weights(2:end, d) = weights(2:end, d) + alpha * input(:, e) * delta;            
    end
 end
 disp(i)      
 deltacounter(i) = counter;
 counter = 0;    
end
toc()
plot(deltacounter);

cm = zeros(10, 10);
out = 0;

weights(1:10,1)

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

