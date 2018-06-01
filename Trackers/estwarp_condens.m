function param = estwarp_condens(frm, tmpl, param, opt)

%%************************1.Candidate Sampling************************%%
%%Sampling Number
n = opt.numsample;
%%Data Dimension
sz = size(tmpl.mean);
N = sz(1)*sz(2);
%%Affine Parameter Sampling
param.param = repmat(affparam2geom(param.est(:)), [1,n]);
randMatrix = randn(6,n);
param.param = param.param + randMatrix.*repmat(opt.affsig(:),[1,n]);
%%Extract or Warp Samples which are related to above affine parameters
wimgs = warpimg(frm, affparam2mat(param.param), sz);
%%************************1.Candidate Sampling************************%%

%%*******************2.Calucate Likelihood Probablity*******************%%
template  = tmpl.mean(:);
wimgsMatrix = reshape(wimgs,[N,n]);
%%L21-Distance
param.conf = zeros(1,n);
for ii = 1:opt.blockNum(1)
    for jj = 1:opt.blockNum(2)
        templateTemp  = template(opt.blockIndex{ii,jj},:);
        templateTemp  = templateTemp./sqrt(sum(templateTemp.^2));
        wimgsMatrixTemp = wimgsMatrix(opt.blockIndex{ii,jj},:);
        wimgsMatrixTemp = wimgsMatrixTemp./...
                          repmat(sqrt(sum(wimgsMatrixTemp.^2)),[length(opt.blockIndex{ii,jj}) 1]);
        param.conf = param.conf + param.weight(ii,jj)*templateTemp'*wimgsMatrixTemp;
    end
end
%%*******************2.Calucate Likelihood Probablity*******************%%

%%*****3.Obtain the optimal candidate by MAP (maximum a posteriori)*****%%
[maxprob,maxidx] = max(param.conf);
param.est = affparam2mat(param.param(:,maxidx));
%%*****3.Obtain the optimal candidate by MAP (maximum a posteriori)*****%%

%%******************4.Collect samples for model update******************%%
param.wimg = wimgs(:,:,maxidx);
tmpl = update_tracker(tmpl, param, opt);
%%******************4.Collect samples for model update******************%%

if  (opt.mu > 100) || (sum(opt.blockNum) == 2)
    return;
end

%%***************5. Collect positive and negative samples***************%%
%Positive
param.paramPos = repmat(affparam2geom(param.est(:)), [1,opt.numPos]);   
affSig         = [opt.rangePos, opt.rangePos, .000, .000, .000, .000];
randMatrix     = randn(6,opt.numPos);
param.paramPos = param.paramPos + randMatrix.*repmat(affSig(:),[1,opt.numPos]);
param.paramPos = affparam2mat(param.paramPos);
%Negative
param.paramNeg = repmat(affparam2geom(param.est(:)), [1,opt.numNeg]);   
affSig         = [opt.rangePos, opt.rangePos, .000, .000, .000, .000];
randMatrix     = randn(6,opt.numNeg);
randMatrix     = randMatrix.*repmat(affSig(:),[1,opt.numNeg]);
randMatrix(1,abs(randMatrix(1,:))<5) = 5*sign(randMatrix(1,abs(randMatrix(1,:))<5));
randMatrix(2,abs(randMatrix(2,:))<5) = 5*sign(randMatrix(2,abs(randMatrix(2,:))<5));
param.paramNeg = param.paramNeg + randMatrix;
param.paramNeg = affparam2mat(param.paramNeg);
%%***************5. Collect positive and negative samples***************%%

%%**************************6. Training Weights*************************%%
wimgsPos = warpimg(frm, param.paramPos, sz);
wimgsNeg = warpimg(frm, param.paramNeg, sz);
confPos  = zeros(opt.blockNum);
confNeg  = zeros(opt.blockNum);
template = tmpl.mean(:);
wimgsMatrixPos = reshape(wimgsPos,[N,opt.numPos]);
wimgsMatrixNeg = reshape(wimgsNeg,[N,opt.numNeg]);
for ii = 1:opt.blockNum(1)
    for jj = 1:opt.blockNum(2)
        templateTemp  = template(opt.blockIndex{ii,jj},:);
        templateTemp  = templateTemp./sqrt(sum(templateTemp.^2));
        wimgsMatrixTemp = wimgsMatrixPos(opt.blockIndex{ii,jj},:);
        wimgsMatrixTemp = wimgsMatrixTemp./...
                          repmat(sqrt(sum(wimgsMatrixTemp.^2)),[length(opt.blockIndex{ii,jj}) 1]);
        confPos(ii,jj)  = sum(templateTemp'*wimgsMatrixTemp);
        wimgsMatrixTemp = wimgsMatrixNeg(opt.blockIndex{ii,jj},:);
        wimgsMatrixTemp = wimgsMatrixTemp./...
                          repmat(sqrt(sum(wimgsMatrixTemp.^2)),[length(opt.blockIndex{ii,jj}) 1]);
        confNeg(ii,jj)  = sum(templateTemp'*wimgsMatrixTemp);
    end
end
confPos = confPos./(opt.numPos*opt.blockNum(1)*opt.blockNum(2));
confNeg = confNeg./(opt.numNeg*opt.blockNum(1)*opt.blockNum(2));
confPos = confPos(:);
confNeg = confNeg(:);
%
f   = confNeg - confPos + opt.mu*param.weight(:);
H = opt.mu*eye(length(f));
Aeq = ones(size(f))';
beq = 1;
lb  = zeros(size(f));
options = optimset('Display','off','LargeScale','off','Diagnostics','off');
w = quadprog(H, f,[],[],Aeq,beq,lb,[],[],options);
param.weight = reshape(w, opt.blockNum(1), opt.blockNum(2));
if  (sum(sum(isnan(param.weight))) > 0) 
    param.weight = ones(opt.blockNum(1),opt.blockNum(2))/(opt.blockNum(1)*opt.blockNum(2));
end
%%**************************6. Training Weights*************************%%