clear all
close all


% Dataset extraction and formatting file- Ensure dataset files are in the
% path

%Dataset extraction, data is placed in files with the naming convention->
%data"order""format" with p denoting PSK, a denoting APSK, no format label
%for QAM
%Lower row numbers denote higher SNRs

load 1024qam40.mat

data1024(1,:)=waveStruct.waveform;

load 1024qam35.mat

data1024(2,:)=waveStruct.waveform;

load 1024qam30.mat

data1024(3,:)=waveStruct.waveform;


load 1024qam25.mat

data1024(4,:)=waveStruct.waveform;

load 1024qam20.mat

data1024(5,:)=waveStruct.waveform;

load 1024qam15.mat

data1024(6,:)=waveStruct.waveform;

load 1024qam10.mat

data1024(7,:)=waveStruct.waveform;

load 1024qam8.mat

data1024(8,:)=waveStruct.waveform;

load 1024qam5.mat

data1024(9,:)=waveStruct.waveform;

load 1024qam3.mat

data1024(10,:)=waveStruct.waveform;

load 1024qam0.mat

data1024(11,:)=waveStruct.waveform;

load 1024qamn5.mat

data1024(12,:)=waveStruct.waveform;

load 1024qamn10.mat

data1024(13,:)=waveStruct.waveform;

%------------------------------------------------------------------------------------
load 512qam40.mat

data512(1,:)=waveStruct.waveform;

load 512qam35.mat

data512(2,:)=waveStruct.waveform;

load 512qam30.mat

data512(3,:)=waveStruct.waveform;


load 512qam25.mat

data512(4,:)=waveStruct.waveform;

load 512qam20.mat

data512(5,:)=waveStruct.waveform;

load 512qam15.mat

data512(6,:)=waveStruct.waveform;

load 512qam10.mat

data512(7,:)=waveStruct.waveform;

load 512qam8.mat

data512(8,:)=waveStruct.waveform;

load 512qam5.mat

data512(9,:)=waveStruct.waveform;

load 512qam3.mat

data512(10,:)=waveStruct.waveform;

load 512qam0.mat

data512(11,:)=waveStruct.waveform;

load 512qamn5.mat

data512(12,:)=waveStruct.waveform;

load 512qamn10.mat

data512(13,:)=waveStruct.waveform;

%------------------------------------------------------------------------------------
load 256qam40.mat

data256(1,:)=waveStruct.waveform;

load 256qam35.mat

data256(2,:)=waveStruct.waveform;

load 256qam30.mat

data256(3,:)=waveStruct.waveform;


load 256qam25.mat

data256(4,:)=waveStruct.waveform;

load 256qam20.mat

data256(5,:)=waveStruct.waveform;

load 256qam15.mat

data256(6,:)=waveStruct.waveform;

load 256qam10.mat

data256(7,:)=waveStruct.waveform;

load 256qam8.mat

data256(8,:)=waveStruct.waveform;

load 256qam5.mat

data256(9,:)=waveStruct.waveform;

load 256qam3.mat

data256(10,:)=waveStruct.waveform;

load 256qam0.mat

data256(11,:)=waveStruct.waveform;

load 256qamn5.mat

data256(12,:)=waveStruct.waveform;

load 256qamn10.mat

data256(13,:)=waveStruct.waveform;

%------------------------------------------------------------------------------------
load 128qam40.mat

data128(1,:)=waveStruct.waveform;

load 128qam35.mat

data128(2,:)=waveStruct.waveform;

load 128qam30.mat

data128(3,:)=waveStruct.waveform;

load 128qam25.mat

data128(4,:)=waveStruct.waveform;

load 128qam20.mat

data128(5,:)=waveStruct.waveform;

load 128qam15.mat

data128(6,:)=waveStruct.waveform;

load 128qam10.mat

data128(7,:)=waveStruct.waveform;

load 128qam8.mat

data128(8,:)=waveStruct.waveform;

load 128qam5.mat

data128(9,:)=waveStruct.waveform;

load 128qam3.mat

data128(10,:)=waveStruct.waveform;

load 128qam0.mat

data128(11,:)=waveStruct.waveform;

load 128qamn5.mat

data128(12,:)=waveStruct.waveform;

load 128qamn10.mat

data128(13,:)=waveStruct.waveform;

%------------------------------------------------------------------------------------
load 64qam40.mat

data64(1,:)=waveStruct.waveform;

load 64qam35.mat

data64(2,:)=waveStruct.waveform;

load 64qam30.mat

data64(3,:)=waveStruct.waveform;

load 64qam25.mat

data64(4,:)=waveStruct.waveform;

load 64qam20.mat

data64(5,:)=waveStruct.waveform;

load 64qam15.mat

data64(6,:)=waveStruct.waveform;

load 64qam10.mat

data64(7,:)=waveStruct.waveform;

load 64qam8.mat

data64(8,:)=waveStruct.waveform;

load 64qam5.mat

data64(9,:)=waveStruct.waveform;

load 64qam3.mat

data64(10,:)=waveStruct.waveform;

load 64qam0.mat

data64(11,:)=waveStruct.waveform;

load 64qamn5.mat

data64(12,:)=waveStruct.waveform;

load 64qamn10.mat

data64(13,:)=waveStruct.waveform;

%------------------------------------------------------------------------------------
load 32qam40.mat

data32(1,:)=waveStruct.waveform;

load 32qam35.mat

data32(2,:)=waveStruct.waveform;

load 32qam30.mat

data32(3,:)=waveStruct.waveform;

load 32qam25.mat

data32(4,:)=waveStruct.waveform;

load 32qam20.mat

data32(5,:)=waveStruct.waveform;

load 32qam15.mat

data32(6,:)=waveStruct.waveform;

load 32qam10.mat

data32(7,:)=waveStruct.waveform;

load 32qam8.mat

data32(8,:)=waveStruct.waveform;

load 32qam5.mat

data32(9,:)=waveStruct.waveform;

load 32qam3.mat

data32(10,:)=waveStruct.waveform;

load 32qam0.mat

data32(11,:)=waveStruct.waveform;

load 32qamn5.mat

data32(12,:)=waveStruct.waveform;

load 32qamn10.mat

data32(13,:)=waveStruct.waveform;

%------------------------------------------------------------------------------------
load 16qam40.mat

data16(1,:)=waveStruct.waveform;

load 16qam35.mat

data16(2,:)=waveStruct.waveform;

load 16qam30.mat

data16(3,:)=waveStruct.waveform;

load 16qam25.mat

data16(4,:)=waveStruct.waveform;

load 16qam20.mat

data16(5,:)=waveStruct.waveform;

load 16qam15.mat

data16(6,:)=waveStruct.waveform;

load 16qam10.mat

data16(7,:)=waveStruct.waveform;

load 16qam8.mat

data16(8,:)=waveStruct.waveform;

load 16qam5.mat

data16(9,:)=waveStruct.waveform;

load 16qam3.mat

data16(10,:)=waveStruct.waveform;

load 16qam0.mat

data16(11,:)=waveStruct.waveform;

load 16qamn5.mat

data16(12,:)=waveStruct.waveform;

load 16qamn10.mat

data16(13,:)=waveStruct.waveform;

%------------------------------------------------------------------------------------
load 8qam40.mat

data8(1,:)=waveStruct.waveform;

load 8qam35.mat

data8(2,:)=waveStruct.waveform;

load 8qam30.mat

data8(3,:)=waveStruct.waveform;

load 8qam25.mat

data8(4,:)=waveStruct.waveform;

load 8qam20.mat

data8(5,:)=waveStruct.waveform;

load 8qam15.mat

data8(6,:)=waveStruct.waveform;

load 8qam10.mat

data8(7,:)=waveStruct.waveform;

load 8qam8.mat

data8(8,:)=waveStruct.waveform;

load 8qam5.mat

data8(9,:)=waveStruct.waveform;

load 8qam3.mat

data8(10,:)=waveStruct.waveform;

load 8qam0.mat

data8(11,:)=waveStruct.waveform;

load 8qamn5.mat

data8(12,:)=waveStruct.waveform;

load 8qamn10.mat

data8(13,:)=waveStruct.waveform;

%------------------------------------------------------------------------------------
load 4qam40.mat

data4(1,:)=waveStruct.waveform;

load 4qam35.mat

data4(2,:)=waveStruct.waveform;

load 4qam30.mat

data4(3,:)=waveStruct.waveform;

load 4qam25.mat

data4(4,:)=waveStruct.waveform;

load 4qam20.mat

data4(5,:)=waveStruct.waveform;

load 4qam15.mat

data4(6,:)=waveStruct.waveform;

load 4qam10.mat

data4(7,:)=waveStruct.waveform;

load 4qam8.mat

data4(8,:)=waveStruct.waveform;

load 4qam5.mat

data4(9,:)=waveStruct.waveform;

load 4qam3.mat

data4(10,:)=waveStruct.waveform;

load 4qam0.mat

data4(11,:)=waveStruct.waveform;

load 4qamn5.mat

data4(12,:)=waveStruct.waveform;

load 4qamn10.mat

data4(13,:)=waveStruct.waveform;

%------------------------------------------------------------------------------------
load BPSK40.mat

data2(1,:)=rxSig;

load BPSK35.mat

data2(2,:)=rxSig;

load BPSK30.mat

data2(3,:)=rxSig;

load BPSK25.mat

data2(4,:)=rxSig;

load BPSK20.mat

data2(5,:)=rxSig;

load BPSK15.mat

data2(6,:)=rxSig;

load BPSK10.mat

data2(7,:)=rxSig;

load BPSK8.mat

data2(8,:)=rxSig;

load BPSK5.mat

data2(9,:)=rxSig;

load BPSK3.mat

data2(10,:)=rxSig;

load BPSK0.mat

data2(11,:)=rxSig;

load BPSKn5.mat

data2(12,:)=rxSig;

load BPSKn10.mat

data2(13,:)=rxSig;

%------------------------------------------------------------------------

load 32PSK40.mat

data32p(1,:) = rxSig;

load 32PSK35.mat

data32p(2,:) = rxSig;

load 32PSK30.mat

data32p(3,:) = rxSig;

load 32PSK25.mat

data32p(4,:) = rxSig;

load 32PSK20.mat

data32p(5,:) = rxSig;

load 32PSK15.mat

data32p(6,:) = rxSig;

load 32PSK10.mat

data32p(7,:) = rxSig;

load 32PSK8.mat

data32p(8,:) = rxSig;

load 32PSK5.mat

data32p(9,:) = rxSig;

load 32PSK3.mat

data32p(10,:) = rxSig;

load 32PSK0.mat

data32p(11,:) = rxSig;

load 32PSKN5.mat

data32p(12,:) = rxSig;

load 32PSKN10.mat

data32p(13,:) = rxSig;


%------------------------------------------------------------------------

load 16PSK40.mat

data16p(1,:) = rxSig;

load 16PSK35.mat

data16p(2,:) = rxSig;

load 16PSK30.mat

data16p(3,:) = rxSig;

load 16PSK25.mat

data16p(4,:) = rxSig;

load 16PSK20.mat

data16p(5,:) = rxSig;

load 16PSK15.mat

data16p(6,:) = rxSig;

load 16PSK10.mat

data16p(7,:) = rxSig;

load 16PSK8.mat

data16p(8,:) = rxSig;

load 16PSK5.mat

data16p(9,:) = rxSig;

load 16PSK3.mat

data16p(10,:) = rxSig;

load 16PSK0.mat

data16p(11,:) = rxSig;

load 16PSKN5.mat

data16p(12,:) = rxSig;

load 16PSKN10.mat

data16p(13,:) = rxSig;

%------------------------------------------------------------------------

load 8PSK40.mat

data8p(1,:) = rxSig;

load 8PSK35.mat

data8p(2,:) = rxSig;

load 8PSK30.mat

data8p(3,:) = rxSig;

load 8PSK25.mat

data8p(4,:) = rxSig;

load 8PSK20.mat

data8p(5,:) = rxSig;

load 8PSK15.mat

data8p(6,:) = rxSig;

load 8PSK10.mat

data8p(7,:) = rxSig;

load 8PSK8.mat

data8p(8,:) = rxSig;

load 8PSK5.mat

data8p(9,:) = rxSig;

load 8PSK3.mat

data8p(10,:) = rxSig;

load 8PSK0.mat

data8p(11,:) = rxSig;

load 8PSKN5.mat

data8p(12,:) = rxSig;

load 8PSKN10.mat

data8p(13,:) = rxSig;


%------------------------------------------------------------------------

load 16apsk40.mat

data16a(1,:) = received_symbols;

load 16apsk35.mat

data16a(2,:) = received_symbols;

load 16apsk30.mat

data16a(3,:) = received_symbols;

load 16apsk25.mat

data16a(4,:) = received_symbols;

load 16apsk20.mat

data16a(5,:) = received_symbols;

load 16apsk15.mat

data16a(6,:) = received_symbols;

load 16apsk10.mat

data16a(7,:) = received_symbols;

load 16apsk8.mat

data16a(8,:) = received_symbols;

load 16apsk5.mat

data16a(9,:) = received_symbols;

load 16apsk3.mat

data16a(10,:) = received_symbols;

load 16apsk0.mat

data16a(11,:) = received_symbols;

load 16apsk-5.mat

data16a(12,:) = received_symbols;

load 16apsk-10.mat

data16a(13,:) = received_symbols;

%------------------------------------------------------------------------

load 32apsk40.mat

data32a(1,:) = received_symbols;

load 32apsk35.mat

data32a(2,:) = received_symbols;

load 32apsk30.mat

data32a(3,:) = received_symbols;

load 32apsk25.mat

data32a(4,:) = received_symbols;

load 32apsk20.mat

data32a(5,:) = received_symbols;

load 32apsk15.mat

data32a(6,:) = received_symbols;

load 32apsk10.mat

data32a(7,:) = received_symbols;

load 32apsk8.mat

data32a(8,:) = received_symbols;

load 32apsk5.mat

data32a(9,:) = received_symbols;

load 32apsk3.mat

data32a(10,:) = received_symbols;

load 32apsk0.mat

data32a(11,:) = received_symbols;

load 32apsk-5.mat

data32a(12,:) = received_symbols;

load 32apsk-10.mat

data32a(13,:) = received_symbols;

%------------------------------------------------------------------------

load 64apsk40.mat

data64a(1,:) = received_symbols;

load 64apsk35.mat

data64a(2,:) = received_symbols;

load 64apsk30.mat

data64a(3,:) = received_symbols;

load 64apsk25.mat

data64a(4,:) = received_symbols;

load 64apsk20.mat

data64a(5,:) = received_symbols;

load 64apsk15.mat

data64a(6,:) = received_symbols;

load 64apsk10.mat

data64a(7,:) = received_symbols;

load 64apsk8.mat

data64a(8,:) = received_symbols;

load 64apsk5.mat

data64a(9,:) = received_symbols;

load 64apsk3.mat

data64a(10,:) = received_symbols;

load 64apsk0.mat

data64a(11,:) = received_symbols;

load 64apsk-5.mat

data64a(12,:) = received_symbols;

load 64apsk-10.mat

data64a(13,:) = received_symbols;

%------------------------------------------------------------------------

load 128apsk40.mat

data128a(1,:) = received_symbols;

load 128apsk35.mat

data128a(2,:) = received_symbols;

load 128apsk30.mat

data128a(3,:) = received_symbols;

load 128apsk25.mat

data128a(4,:) = received_symbols;

load 128apsk20.mat

data128a(5,:) = received_symbols;

load 128apsk15.mat

data128a(6,:) = received_symbols;

load 128apsk10.mat

data128a(7,:) = received_symbols;

load 128apsk8.mat

data128a(8,:) = received_symbols;

load 128apsk5.mat

data128a(9,:) = received_symbols;

load 128apsk3.mat

data128a(10,:) = received_symbols;

load 128apsk0.mat

data128a(11,:) = received_symbols;

load 128apsk-5.mat

data128a(12,:) = received_symbols;

load 128apsk-10.mat

data128a(13,:) = received_symbols;




%Declare Dataset Matrices

data2=data2(:,1:600000);
data4=data4(:,1:600000);
data8=data8(:,1:600000);
data16=data16(:,1:600000);
data32=data32(:,1:600000);
data64=data64(:,1:600000);
data128=data128(:,1:600000);
data256=data256(:,1:600000);
data512=data512(:,1:600000);
data1024=data1024(:,1:600000);

%Combine dataset matrices into one large matrix

data =[ data2; data4; data8;data16; data32 ;data64; data128;  data256;   data8p; data16p; data32p; data16a;data32a; data64a ; data128a]; %  data512; data1024 ;
nP = imag(data);
nA = real(data);

%Loop variable initialisation
a=1;

%Set defines dataset size, nmods the number of modulatiation schemes
set=1000;
nmods=15;
nwaves=nmods*13;

nsamples=length(data2);
nloops=nsamples/set;

%Optional quantisation to prepare for input to Verilog system
    nA=fixed_point_quantise(nA,14,4,10,1);
    nP=fixed_point_quantise(nP,14,4,10,1);

%Loop for the number of waves    
for i=1:nwaves
    

    %Loop for the number of samples per wave, performs rectangular to polar
    %conversion
    for j = 1:nsamples
        arg(i,j) = mod(atan2d(nP(i,j),nA(i,j)),360);
        abz(i,j) = sqrt(nA(i,j)^2+nP(i,j)^2);
    end

    %Optional quantisation to mimic Verilog system
    abz=fixed_point_quantise(abz,10,2,8);
    arg=fixed_point_quantise(arg,10,9,1);
    
    %Performs sorting operation similar to SR unit in Verilog
    for j = 1:nloops
            s(1,:) = sort(arg(i,j*set-(set-1):j*set));
            s(2,:) = sort(abz(i,j*set-(set-1):j*set));

        %DBSCAN performed on both the arguments and magnitudes
        %Case 1 sets argument epsilon and minpts, case 2 magnitude
        for p=1:2 
            switch p
                case 1
                        e=0; 
                        m=1;
                case 2 

                    e=0;  
                    m=1;
            end
            u = mode(s(p,:));

            %initialise DBSCAN variables to 0
            clustercount=0;
            pointcount=0;

            %perform 1D DBSCAN similarly to Verilog implementation
        for k = 2:set
               if (s(p,k)-s(p,k-1)<=e)
                    pointcount=pointcount +1;
               elseif (s(p,k)-s(p,k-1)>=e) && pointcount>=m
                   pointcount=0;
                   clustercount=clustercount+1;
               else 
                   pointcount = 0;
               end
               if (k==set)&&(pointcount>=m)&&(u~=0)
                    clustercount=clustercount+1;
                  
               end
        end
     %Saves obtained DBSCAN result, alongside target value
     if (u~=0)
     datamatrix(a,p)=clustercount;
     datamatrix(a,3)=i;
   
     end
     end
a=a+1;

    end


end


%Final formatting to prepare target column for classification training
DM = datamatrix;
iloops=nloops*nwaves;
for i = 1:iloops
   
  DM(i,3)=ceil(datamatrix(i,3)/13);
end



%Quantisation function

function quantised_matrix = fixed_point_quantise(input_matrix, total_bits, int_bits, frac_bits, is_signed)
    % Default to unsigned representation
    if nargin < 5
        is_signed = false;
    end
    
    % Verify that total_bits = int_bits + frac_bits
    if total_bits ~= (int_bits + frac_bits)
        error('Total bits must equal integer bits plus fractional bits');
    end
    
    % Calculate the scaling factor for the fractional part
    scale = 2^frac_bits;
    
    % Calculate the maximum and minimum representable values
    if is_signed
        % For signed representation:
        % - The range is [-2^(int_bits-1), 2^(int_bits-1)-2^(-frac_bits)]
        max_val = 2^(int_bits-1) - 2^(-frac_bits);
        min_val = -2^(int_bits-1);
    else
        % For unsigned representation:
        % - The range is [0, 2^int_bits-2^(-frac_bits)]
        max_val = 2^int_bits - 2^(-frac_bits);
        min_val = 0;
    end
    
    % Scale the input matrix
    scaled_matrix = input_matrix * scale;
    
    % Truncate (floor) instead of rounding
    truncated_matrix = floor(scaled_matrix);
    
    % Apply saturation (clipping)
    saturated_matrix = min(max(truncated_matrix, min_val * scale), max_val * scale);
    
    % Scale back to get the quantised values
    quantised_matrix = saturated_matrix / scale;
end


