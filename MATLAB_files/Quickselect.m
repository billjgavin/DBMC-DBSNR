clear sDM

%Script to extract single SNR dataset from DM matrix

q=1;    %Loop variable init
set=500;    %Dataset Size
nwaves=195;    %Number of waves total (nmods*13)
nmods=nwaves/13;    %Number of modulation schemes
nsamples=length(data2);
nloops=nsamples/set;

%Select SNR to extract
n=0
% SNR = 40 35 30 25 20 15 10 8 5 3 0 - 5 -10
% n =   0  1  2  3  4  5  6  7 8 9 10 11  12


%Performs Dataset extractions
select=nloops*n;
sz=nloops*13;
for i = 0:nmods-1
    sDM(q:q+nloops-1,:) = DM(i*sz+select+1:i*sz+select+nloops,:);
    sDM(q:q+nloops-1,3) = i+1;
    q=q+nloops;
end


%Plot feature space (optional)
gscatter(sDM(:,1),sDM(:,2),sDM(:,3))
legend_labels = {'2QAM', '4QAM', '8QAM', '16QAM', '32QAM', '64QAM', '128QAM','256QAM', '8SPK','16PSK','32PSK','16APSK','32APSK','64APSK','128APSK'};%'8QAM',,'512QAM','1024QAM'
legend(legend_labels, 'Location', 'best');
ylabel('No. of Magnitude Clusters per Dataset');
xlabel('No. of Argument Clusters per Dataset');
grid on

%Save inputs and targets to CSV for training (Optional - Data taken from
%Verilog design performs better)
writematrix(sDM(:,1:2), '1_inputs_v.csv');
writematrix(sDM(:,3), '1_targets_v.csv');