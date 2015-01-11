function [C]=changeMnl(R,editstart,editend)
%changeMnl - interpolates elements number start-slut in vector R
%
%   Syntax:
%           [C]=changeMnl(R,start,slut)
%   Argument:
%           R       - 1*n Vector to be partially interpolated
%           editstart   - first element in R to be interpolated 
%           editend    - last element of R to be interpolated
%           
%   Returns:
%           C - 1*n vector with interpolated part
%          
%   Description:
%           The program calculates a gradient of waterheight based on 
%           preceeding and subsequent (to elements start and slut
%           respectively) values of waterheight. And applies that gradient
%           in place of elements from start to slut
%           
%   Example:
%           [C]=changeMnl([1 2 7 4 5],3,3)
%   Author: Josefina Alm?n 2015-01-10


C=R;
grad=(R(editend+1)-R(editstart-1))/(editend-editstart+2);     
k=1;
    
for i=editstart:editend
    C(i)=R(editstart-1)+grad*k;
    k=k+1;
end

    