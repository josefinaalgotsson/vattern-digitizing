function [digitized,band,timev,pixvect]=Digit7(Ag,epc,spc,s,mpp,TS,TE,i,edits);
%Digit7 - Digitizes the curve in a a graph from a unit8 image.Also saves the 
%         section of the image which has been subject to digitizing and
%         coordinates interpolation of sections of water height vector.
%
%   Syntax:
%           [R,dp,t,Vpix] =  Digit7(Ag,ep,sp,s,e,mpp,TS,TE,i,edits)
%   Argument:
%           Ag      - The image of the graph: a m*n*3 unit8 matrix
%           epc     - scalar: Column value of pixel which contains end value of
%           curve
%           spc     - scalar: Column value of pixel which contains start value of
%           curve
%           s       - scalar: first value of water height in curve
%           e       - scalat: last value of water height in curve
%           mpp     - scalar: coefficient meters/pixel
%           TS      - Start time of measurements datenum
%           TE      - End time of measurements in datenum-format
%           i       - 
%           edits   -
%   Returns:
%           digitized   - 1*m vector containing curve values m=numbers of pixel
%           between sp and ep.
%           timev       - timevector
%           band        - Digitation band; 
%           pixvect     - Vector containing what pixels are chosen to respresent
%           the curve       
%   Description:
%           The program sets up a time vector and prelocates a vector for
%           digitized values. 
%           
%   
%   Author: Josefina Alm?n 2015-01-10

close all
timev=linspace(TS,TE,epc(1)-spc(1)+1);  %Time vector
%digitized=zeros(1,epc-spc+1);               %Prelocating vectors of apropriate size
                                    %for water height values

                
%-------------------------------------------------------------------------%
%          FINDING PIXELS, MAKING VECTORS OF DIGITIZED VALUES             %
%-------------------------------------------------------------------------%

%-----------RED CHANNEL-------------%                                       
[digitized,band,pixvect]=findpix8(1,spc,epc,s,i,Ag,mpp);% Finds edges of curve and 
%                                           chooses point between them to 
%                                           represent location of curve
%                                           relative to sp
%
%-----------------------------------%

%------------------%INTERPOLATING PARTS OF WATER HEIGHT CURVE%------------------%   
  
for n=1:2:10
    if edits(n) ~=0
        
      [digitized]=changeMnl(digitized,edits(n),edits(n+1));
      
    end
end
        
%-------------------------------------------------------------------------%
