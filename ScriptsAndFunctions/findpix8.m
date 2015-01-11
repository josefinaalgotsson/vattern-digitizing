function [Vwat,dp,Vpix]=findpix8(c,spc,epc,s,i,A,mpp);
%findpix8 - finds strongest positive and negative gradient in one
%           channel of one column at a time in the image of a graph.
%
%   Syntax:
%           [Vwat,dp,Vpix]=findpix8(c,sp,ep,s,i,A,mpp);
%   Argument:
%           c    -  determines what channel is searched (either 1, 2 or 3
%           in a unit 8 image)
%           spc   - column value of pixel representing start of curve 
%           epc    - column value of pixel representing end of curve 
%           s     - starting value of measurements in image    
%           i     - %row values for digitzing-band [upper limit, lower limit]
%           A     - matrix containing image of graph
%           mpp   - coefficient meters/pixel used in translating 
%                   pixel-height to measurement height 
%
%   Returns:
%           Vwat - Vector containing digitized measurements
%           Vpix - vector containing chosen pixels representing
%           measurements
%          
%   Description:
%           The program calculates gradients in the columns of the image of
%           the graph. It chooses the pixel between the strongest positive
%           and the strongest negative gradient to represent the curve. It
%           translates the position of that pixel relative to the position
%           of the first pixel of measurements to a meaningful value of
%           water height.
%   Example:
%           [Vwat,dp,Vpix]=findpix8(1,sp,ep,s,i,Ag,mpp);
%   Author: Josefina Alm?n 2015-01-11

dp=A(i(1):i(2),spc:epc,:);

a=zeros((i(2)-i(1)+1),1);
k=1;
for x=spc:epc;
    a(1:end)=A(i(1):i(2),x,c);
    g=gradient(a);
    
[p]=mean(find(g==min(g(:))));
[q]=mean(find(g==max(g(:))));

dp(round(p),k,:)=0;
dp(round(q),k,:)=0;

point=round(mean([p q]));
Vpix(k)=i(1)+point-1;

if x==spc;
    Vwat(1)=s;
else
Vwat(k)=s+((Vpix(1)-Vpix(k))*mpp);
end
k=k+1;
end