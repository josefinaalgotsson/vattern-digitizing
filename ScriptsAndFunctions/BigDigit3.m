%Author: Josefina Almen 2015-01-11

%Description: Loads week-specific workspaces based on informarion in 
%the matrix "Tabell" . It chooses one row at a time from table "Tabell" and
%coordinates digitizing for the image represented by that row. 

clc
clear
close all

tic;            %Measures time it takes to run BigDigit3
load Auto
%Auto contains information necessary for simple coordination of
%digitizing images

%The matrix "Tabell" contains information regarding date, starting value and
%ending value of water height etc for one week per row.
%The workspace Auto also contains some string vectors usefull in displaying
%the resulting graphs with understandable axis ticks instead of datenum-format:

%StartDates             Vector containing starting dates for each week in
%                       datenum format
%StartDateString        vector containing start dates and time for each week in
%                       string format
%StartDateString2       vector containing start dates for each week in
%                       string format     
%numOfHours             Number of hours between first and last measurement
%hourticks              Vector containing hour-wise ticks in datenum format
%hourstring             Vector containing hour-wise ticks in string format


%-------------------------------------------------------------------------%


%Adding RR to workspace to allocate space for year-vector of water height
%Adding T to workspace to allocate space for year-vector of time

RR=[]
T=[]
for n=1:53
    
    name=[num2str(Tabell(n,1)),'-'];
  
    if Tabell(n,2)<10;
        name=[num2str(name),'0',num2str(Tabell(n,2)),'-'];
    else
        name=[num2str(name),num2str(Tabell(n,2)),'-'];
    end
    
    if Tabell(n,3)<10
        name=[num2str(name),'0',num2str(Tabell(n,3)),'var.mat']
    else
        name=[num2str(name),num2str(Tabell(n,3)),'var.mat']
    end
    

%loads week-specific workspace YYYY-MM-DDvar.mat    
load(num2str(name));

%Collects week-specific information from Tabell and assigns parameter-names

TS=datenum(Tabell(n,1:6));          %starting date and time
TE=datenum(Tabell(n,7:12));         %ending date and time
s=Tabell(n,13);                     %starting value of water height
e=Tabell(n,14);                     %ending value of water eight
spc=Tabell(n,15);                   %column value of pixel where start of line is found
epc=Tabell(n,16);                    %column value of pixel where end of line is found
mpp=Tabell(n,17);                   %coefficient meters/pixel
i=Tabell(n,18:19);                  %row values for digitzing-band [upper, lower]
edits=Tabell(n,20:29);              %Vector containing pieces of water 
                                    %height vector that need to be interpolated   


%------------------------------------------------------------------------%
%                  Digitizing                                            %
%------------------------------------------------------------------------%
                                  
[R,dp,t,Vpix]=Digit7(Ag,epc,spc,s,mpp,TS,TE,i,edits);
date=datestr(TS,29);

%------------------------------------------------------------------------%
%                  Correcting end value                                  %
%------------------------------------------------------------------------%

%Calculating difference between digitized end value and noted end value from
%paper week-graph and stores in a vector.
DifLogAut(n)=R(end)-e;
    
%calculates the correction factor for week-vector of water height    
fact=e-R(end);
grad_vect=linspace(0,fact,length(R));   

%Adds a gradient to the water height vector rendering the last digitized
%value of water height identical to that specified in paper graph
R=R+grad_vect;
save([num2str(date),'out'],'t','R','dp','Vpix');

%------------------------------------------------------------------------%
%                                                                        %
%------------------------------------------------------------------------%


%calculates how many elements will be added to year-vector
addlength=length(R)-1;
newlength=length(RR)+addlength;

%Adds week vector of water height and time to year-vector of water height
%and time 
RR( length(RR)+1 : newlength )=R(1:end-1);      %year vector of water height
T( length(T)+1 : newlength )=t(1:end-1);        %year vector of time
      
end

plot(T,RR);
set(gca,'xtick',StartDates);
set(gca,'xticklabel',StartDateString);
grid on;

save(['DigitizingOut'],'T',...
                        'RR',...
                        'hourstring',...
                        'hourticks',...
                        'numOfHours',...
                        'StartDates',...
                        'StartDateString',...
                        'StartDateString2',...
                        'Tabell',...
                        'DifLogAut');
toc;