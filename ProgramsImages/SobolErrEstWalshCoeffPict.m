%Automatic cubature with Sobol sequences

%% Garbage collection and initialization
format compact %remove blank lines from output
format long e %lots of digits
clear all %clear all variables
close all %close all figures
set(0,'defaultaxesfontsize',30,'defaulttextfontsize',30) %make font larger
set(0,'defaultLineLineWidth',3) %thick lines
set(0,'defaultTextInterpreter','latex') %latex axis labels
set(0,'defaultLineMarkerSize',40) %latex axis labels
tic

%% Initialize parameters
mmax=20; %maximum number of points is 2^mmax
mdualvec=10:13;
mplot=16;
% mmax=16; %maximum number of points is 2^mmax
% mdualvec=11;
% mplot=14;
mlag=4;
%testfun=@(x) x; exactinteg=1/2; d=1; %test function
%testfun=@(x) x.^2; exactinteg=1/3; d=1; %test function
testfun=@(x) exp(-3*x).*sin(10*x.^2); d=1; %test function
%a=20; testfun=@(x) sin(a*x); exactinteg=(1-cos(a))/a; d=1; %test function
%testfun=@(x) x(:,1).*x(:,2); exactinteg=1/4; d=2; %test function
%testfun=@(x) sin(x(:,1)).*x(:,2)+exp(x(:,1)); exactinteg=(1-cos(1))/2 + (exp(1)-1); d=2; %test function
%a=3; d=5; testfun=@(x) exp(a*sum(x,2))./(((exp(a)-1)/a).^d); exactinteg=1; %test function
sobstr=sobolset(d);
sobstr=scramble(sobstr,'MatousekAffineOwen');
sobol=qrandstream(sobstr);
%Stilde=zeros(mmax-mmin+1,1);

%% Plot function
figure
xplot=(0:0.002:1);
yplot=testfun(xplot);
plot(xplot,yplot,'b-');
ymin=1.1*min(yplot);
ymax=1.1*max(yplot);
axis([0 1 ymin ymax])

%% Evaluate Function and FWT
n=2^mmax;
%xpts=qrand(sobol,n);
xpts=sobstr(1:n,1:d);
y=testfun(xpts);
yval=y;
yfwt=fwht(y);

%% Compute initial FWT
for l=0:mmax-1
   nl=2^l;
   nmmaxlm1=2^(mmax-l-1);
   ptind=repmat([true(nl,1); false(nl,1)],nmmaxlm1,1);
   evenval=y(ptind);
   oddval=y(~ptind);
   y(ptind)=(evenval+oddval)/2;
   y(~ptind)=(evenval-oddval)/2;
end

%% Create kappanumap
kappanumap=(1:n)'; %initialize map
for l=mmax-1:-1:1
   nl=2^l;
   oldone=abs(y(kappanumap(2:nl))); %earlier values of kappa, don't touch first one
   newone=abs(y(kappanumap(nl+2:2*nl))); %later values of kappa, 
   flip=find(newone>oldone); %
   temp=kappanumap(nl+1+flip);
   kappanumap(nl+1+flip)=kappanumap(1+flip);
   kappanumap(1+flip)=temp;
   %keyboard
end
ymap=y(kappanumap);



%% Plot FW coefficients
nplot=2^mplot;
yfwtabs=abs(ymap(1:nplot));
ymin=max(1e-15,min(yfwtabs));
ymax=max([1; yfwtabs]);
for mdual=mdualvec
   ndual=2^mdual;
   whdual=ndual*(1:2^(mplot-mdual)-1);
   whsmall=1:ndual-1;
   whbig=ndual:nplot-1;
   muse=mdual-mlag;
   nuse=2^muse;
   whuse=nuse/2:nuse-1;
   figure
   h=loglog(whsmall,yfwtabs(whsmall+1),'g.',...
      whbig,yfwtabs(whbig+1),'k.',...
      whuse,yfwtabs(whuse+1),'b.',...
      whdual,yfwtabs(whdual+1),'r.','MarkerSize',10);
   set(h([3 4]),'MarkerSize',20)
   maxexp=floor(log10(nplot-1));
   set(gca,'Xtick',10.^(0:maxexp))
   axis([1 nplot-1 ymin ymax])
   xlabel('$\kappa$')
   ylabel('$|\hat{f}_{\kappa}|$')
   legend(h([4 2 3]),{['err $\le \hat{S}(0,' int2str(mdual) ')$'],...
      ['$\check{S}(' int2str(mdual) ')$'],...
      ['$S(' int2str(mdual-mlag) ')$']},...
      'location','southwest')
   legend('boxoff')
   set(gca,'Position',[0.2 0.155 0.75 0.77])
   eval(['print -depsc PlotFWTCoefUse' int2str(nuse) '.eps'])
end


toc 




