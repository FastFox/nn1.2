function step4()
    load digits
    beta = 1;
    func = 'linear';
    options = zeros(14);
    target = zeros(size(trainingd,2),10);
    size(target)
    size(training)
    for d=1:10
        %Create the target vector from training data
        for j = 1:size(target,1)
            if trainingd(j) == d-1
                target(j, d) = 1;
            end
        end        
        %Create the nets
        net(d) = glm(256,1,func);
        %Train the nets
        glmtrain(net(d), options, training', target(:,d));
        %Test errors
        glmerr(net(d), training', target(:,d))
    end
end