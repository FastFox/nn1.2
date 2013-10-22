function step4()
    load digits
    func = 'linear';
    cm = zeros(10);
    cm2 = zeros(10);
    options = foptions;
    options(1) = 1;
    options(14)= 10;
    target = zeros(size(trainingd,2),10);
    output = zeros(size(trainingd,2),10);
    output2 = zeros(size(testdatad,2),10);
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
        %Test errors on training
        output(:,d) = glmfwd(net, training');
        for e=1:1707
            if round(output(e,d))==1 && trainingd(e)==d-1
                cm(d,d) = cm(d,d) + 1;
            else
                cm(trainingd(e)+1,d) = cm(trainingd(e)+1,d);
            end
        end       
        %Test errors on testset
        output2(:,d) = glmfwd(net, testdata');
        round(output2(:,d))
        for e=1:1000
            if round(output2(e,d))==1 && testdatad(e)==d-1
                cm2(d,d) = cm2(d,d) + 1;
            else
                cm2(testdatad(e)+1,d) = cm2(testdatad(e)+1,d);
            end
        end
        
        disp(['Percentage correct: ' num2str(size(nonzeros(target(:,d)==round(output(:,d))),1)/size(target(:,d),1))]);
    end  
    cm
    cm2
end