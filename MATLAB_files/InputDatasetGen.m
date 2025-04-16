clear i_values
clear q_values

%Decide on SNR or modulation scheme to extract
%If class = 1 then 
%n    = 0    1    2    3     4     5     6      7      8      9  
%data = 2QAM 4QAM 8QAM 16QAM 32QAM 64QAM 128QAM 256QAM 512QAM 1024QAM 
%n    = 10   11    12    13     14     15     16
%data = 8PSK 16PSK 32PSK 16APSK 32APSK 64APSK 128APSK

%Modulation scheme ordering determined by placement in data matrix in
%DataExtraction.m

%If Class = 0 then
%n    = 0    1    2    3     4     5     6      7      8      9  
%data = 40dB 35dB 30dB 25dB  20dB  15dB  10dB   8dB    5dB    3dB 
%n    = 10   11    12   
%data = 0dB -5dB -10dB 

n = 0; %Decide on SNR or modulation scheme to extract
num_in_data = 15; %Declare the number of different modulation scheme in data matrix
class=1;  %Obtain Classification input data (class=1) or Regression data (class=0)

if class==1
    for i=0:num_in_data-1
        %Extract data from modulation schemes which were input to the data matrix at a particular SNR  
        i_values(i*600000+1:i*600000+600000) = (nA(i*13+n+1,1:600000)*1024);
        q_values(i*600000+1:i*600000+600000) = (nP(i*13+n+1,1:600000)*1024);
    
    end
    
    %Save to a .csv
    writematrix(i_values', '1_nP_class_v.csv');
    writematrix(q_values', '1_nA_class_v.csv');

elseif class==0 

    t=n*13+1;

    for i=0:12
        %Extract data of a particular modulation scheme across all SNRs   
        i_values(i*600000+1:i*600000+600000) = (nA((i+t),1:600000)*1024);
        q_values(i*600000+1:i*600000+600000) = (nP((i+t),1:600000)*1024);
    
    end
    %Save to a .csv    
    writematrix(i_values', '1_nP_snr_v.csv');
    writematrix(q_values', '1_nA_snr_v.csv');
end