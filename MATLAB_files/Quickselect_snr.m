clear sDM

%Script to extract single modulation scheme from DM Matrix

q=1;  %Loop value init
set=1000;   %Dataset Size
nwaves=195;     %Total Number of waves
nmods=nwaves/11;   %Total number of modulation schemes
nsamples=length(data2);     
nloops=nsamples/set;


%Select Modulation scheme to extract
n=13;
%Mod = 2QAM 4QAM 8QAM 16QAM 32QAM 64QAM 128QAM 256QAM 512QAM 1024QAM 8PSK
%n =     1    2    3    4     5     6      7    8        9     10      11
%Mod = 16PSK 32PSK 16APSK 32APSK 64APSK 128APSK
%n =     12    13    14      15    16     17

%Numbering dependend upon modulation scheme ordering in extraction script
%"data" matrix

%Extract modulation scheme data
select=nloops*n;
sz=nloops*13;

    sDM = DM(n*sz-sz+1:n*sz,:);
    
% Label SNR of DM matrix files
o=1;
for i=1:size(datamatrix,1)
    t = mod(datamatrix(i,3),13);
    switch t
        case 1 
            DM(o,3)=-10;
        case 2
            DM(o,3)=-5;
        case 3
            DM(o,3)=0;
        case 4
            DM(o,3)=3;
        case 5
            DM(o,3)=5;
        case 6
            DM(o,3)=8;
        case 7
            DM(o,3)=10;
        case 8
            DM(o,3)=15;
        case 9
            DM(o,3)=20;
        case 10
            DM(o,3)=25;
        case 11
            DM(o,3)=30;
        case 12
            DM(o,3)=35;
        case 0
            DM(o,3)=40;
    end
        o=o+1; 
    
end


%Writes dataset to CSV file for training, (Data taken from Verilog
%operation provides superior results)
writematrix(sDM(:,1:2),'1_inputs_snr_v.csv')
writematrix(sDM(:,1:2),'1_inputs_snr_v_v.csv')
writematrix((sDM(:,3)+10),'1_targets_snr_v.csv')



% Plots feature space
gscatter(sDM(:,1),sDM(:,2),sDM(:,3))
legend_labels = {'-10', '-5',  '0', '3', '5', '8','10', '15','20','25','30','35','40'};%'8QAM','512QAM','1024QAM',
legend(legend_labels, 'Location', 'best');
ylabel('No. of Magnitude Clusters per Dataset');
xlabel('No. of Argument Clusters per Dataset');
grid on