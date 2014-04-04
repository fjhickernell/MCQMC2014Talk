%Test the new cubMC routine
function res=TestCubatureDiffSettings(test,fun,param)
tstartwhole=tic;

% Initialize variables
tempinitial=zeros(test.nrep,1);
res.dim=tempinitial;
if strcmp(fun.funtype,'step')
    res.exactkurtosis=tempinitial;
    res.estvariance=tempinitial;
    res.exactvariance=tempinitial;
end
if strcmp(fun.funtype,'exp')
    res.exactkurtosis=tempinitial;
    res.estvariance=tempinitial;
    res.exactvariance=tempinitial;
end
if strcmp(fun.funtype,'gaussian')
    res.exactkurtosis=tempinitial;
    res.estvariance=tempinitial;
    res.exactvariance=tempinitial;   
end
if any(strcmp('iid',test.whichsample))
    res.iidexit=tempinitial;
    res.iidQ=tempinitial;
    res.iiderr=tempinitial;
    res.iidtime=tempinitial;
    res.iidneval=tempinitial;
end
if any(strcmp('iidheavy',test.whichsample))
    res.iidheavyexit=tempinitial;
    res.iidheavyQ=tempinitial;
    res.iidheavyerr=tempinitial;
    res.iidheavytime=tempinitial;
    res.iidheavyneval=tempinitial;
end
if any(strcmp('cubSobol',test.whichsample))
    res.Sobolexit=tempinitial;
    res.SobolQ=tempinitial;
    res.Sobolerr=tempinitial;
    res.Soboltime=tempinitial;
    res.Sobolneval=tempinitial;
end
nsigold=param.n0;

for irep=1:test.nrep
    if round(irep/test.howoftenrep)==irep/test.howoftenrep, irep, end
    [testfun,fun,param]=test.randchoicefun(fun,param,test.randch,irep);
    res.dim(irep)=param.dim;
    if strcmp(fun.funtype,'step')
        res.exactkurtosis(irep)=param.exactkurtosis;
        res.exactvariance(irep)=param.exactvariance;
    end
    if strcmp(fun.funtype,'exp')
        res.exactkurtosis(irep)=param.exactkurtosis;
        res.exactvariance(irep)=param.exactvariance;

    end
    if strcmp(fun.funtype,'gaussian')
        res.exactkurtosis(irep)=param.exactkurtosis;
        res.exactvariance(irep)=param.exactvariance;

    end
    
    % Evaluate integral for iid
    if any(strcmp('iid',test.whichsample))
        param.n0=nsigold;
        param.sample='iid';
        [~,param]=cubMC(testfun,param.interval,param);
        if irep==1; 
            res.iidkurtmax=param.kurtmax; 
        end
        res.iidexit(irep)=param.exit;
        res.iidQ(irep)=param.Q;
        res.iiderr(irep)=abs(param.exactintegral-param.Q);
        res.iidtime(irep)=param.time;
        res.iidneval(irep)=param.n;
        res.estvariance(irep)=param.estvari;
    end

    % Evaluate integral for heavy duty iid
    if any(strcmp('iidheavy',test.whichsample))
        param.n0=nsigold*2^5; %larger n to compute sigma
        param.sample='iid';
        [~,param]=cubMC(testfun,param.interval,param);
        if irep==1; res.iidheavykurtmax=param.kurtmax; end
        res.iidheavyexit(irep)=param.exit;
        res.iidheavyQ(irep)=param.Q;
        res.iidheavyerr(irep)=abs(param.exactintegral-param.Q);
        res.iidheavytime(irep)=param.time;
        res.iidheavyneval(irep)=param.n;
        res.estvariance(irep)=param.estvari;
    end
    
    % Evaluate integral using cubSobol
    if any(strcmp('cubSobol',test.whichsample))
        [q,~,time,n,overbudget]=...
           cubSobol(testfun,param.dim,param.tol,param.measure);
        res.Sobolexit(irep)=overbudget;
        res.SobolQ(irep)=q;
        res.Sobolerr(irep)=abs(param.exactintegral-q);
        res.Soboltime(irep)=time;
        res.Sobolneval(irep)=n;
    end  
end

timestamp=datestr(now,'yyyy-mm-dd-HH-MM');
save(['TestCubature-' fun.funtype '-' param.measure '-' timestamp ...
   '-N-' int2str(test.nrep) '-d-' int2str(param.dim)  ...
    '-tol-' num2str(param.tol) '.mat'])

toc(tstartwhole)