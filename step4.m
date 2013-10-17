function step4()
    load digits

    func = 'linear';
    options = foptions;
    options(1) = 1;
    options(14)= 10;
    target = zeros(size(trainingd,2),10);
    output = zeros(size(trainingd,2),10);
    size(target)
    size(training)
    for d=1:10
        disp(['Digit:' num2str(d)]);
        %Create the target vector from training data
        for j = 1:size(target,1)
            if trainingd(j) == d-1
                target(j, d) = 1;
            end
        end        
        %Create the net
        net = glm(256,1,func);
        %Train the nets
        net = glmtrain(net, options, training', target(:,d));
        %Test errors
        output(:,d) = glmfwd(net, training');
        disp(['Percentage correct: ' num2str(size(nonzeros(target(:,d)==round(output(:,d))),1)/size(target(:,d),1))]);
    end
end