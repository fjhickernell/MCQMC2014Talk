%Display TestMCDiffSettings results
clear all %clear all variables
close all %close all figures
set(0,'defaultaxesfontsize',20,'defaulttextfontsize',20) %make font larger
set(0,'defaultLineLineWidth',3) %thick lines
set(0,'defaultTextInterpreter','tex') %tex axis labels
set(0,'defaultLineMarkerSize',40) %larger markersset(0,'defaultaxesfontsize',20,'defaulttextfontsize',20)
load TestCubature-geomean-normal-2014-04-03-21-26-N-1000-d-64-tol-0.002.mat
plotTest.plotcolor='color';
plotTest.logerrlo=-5;
plotTest.logerrhi=0;
plotTest.logtimelo=-3;
plotTest.logtimehi=3;
plotTest.errlowlimit=10^plotTest.logerrlo;
plotTest.errhilimit=10^plotTest.logerrhi;
plotTest.timelowlimit=10^plotTest.logtimelo;
plotTest.timehilimit=10^plotTest.logtimehi;
plotTest.linewidth=2;
plotTest.nrep=test.nrep;
plotTest.namepref=fun.funtype;
if strcmp(fun.funtype,'step') 
plotTest.kurtvec=res.exactkurtosis;
plotTest.namepref=[plotTest.namepref 'd=' int2str(param.dim)];
end
if strcmp(fun.funtype,'gaussian') 
plotTest.kurtvec=res.exactkurtosis;
plotTest.namepref=[plotTest.namepref 'd=' int2str(param.dim)];
end

%% Plot iid results
if any(strcmp('iid',test.whichsample))
    plotTest.err=res.iiderr;
    plotTest.time=res.iidtime;
    plotTest.exit=res.iidexit;
    plotTest.kurtmax=res.iidkurtmax;
    plotTest.name=[plotTest.namepref 'iidErrTime'];
    plotTest.defaultcolor=[1,0,0];
    if any(strcmp('black',plotTest.plotcolor))
    plotTest.ptsize=150;
    plotTestcubMCblack(plotTest,param)
    end
    if any(strcmp('color',plotTest.plotcolor))
    plotTest.ptsize=400;
    plotTestcubMCcolor(plotTest,param)
    end
    plotTest=rmfield(plotTest,'kurtmax');
end
% 
%% Plot iid heavy duty results
if any(strcmp('iidheavy',test.whichsample))
    plotTest.err=res.iidheavyerr;
    plotTest.time=res.iidheavytime;
    plotTest.exit=res.iidheavyexit;
    plotTest.kurtmax=res.iidheavykurtmax;
    plotTest.name=[plotTest.namepref 'iidheavyErrTime'];
    plotTest.defaultcolor=[1,0,0];
    if any(strcmp('black',plotTest.plotcolor))
    plotTest.ptsize=150;
    plotTestcubMCblack(plotTest,param)
    end
    if any(strcmp('color',plotTest.plotcolor))
    plotTest.ptsize=400;
    plotTestcubMCcolor(plotTest,param)
    end
    plotTest=rmfield(plotTest,'kurtmax');
end

%% Plot Sobol results
if any(strcmp('cubSobol',test.whichsample))
    plotTest.err=res.Sobolerr;
    plotTest.time=res.Soboltime;
    plotTest.exit=res.Sobolexit;
    plotTest.name=[plotTest.namepref 'cubSobolErrTime'];
    plotTest.defaultcolor=[1 0 0];
    if any(strcmp('black',plotTest.plotcolor))
    plotTest.ptsize=150;
    plotTestcubMCblack(plotTest,param)
    end
    if any(strcmp('color',plotTest.plotcolor))
    plotTest.ptsize=400;
    plotTestcubMCcolor(plotTest,param)
    end
end

