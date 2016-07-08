//pre emphasis apllied
function[x] = preEmp(s)
    s_cpy = s;
    l = length(s);
    z = [0];
    z(2:length(s)+1) = s;
    s_cpy(l+1) = 0;
    z = s_cpy - 0.95*z
    x = z(1:l);
endfunction;

//Division into frames
//win_length = 480;
//win_sep = 60;
function[x] = framing_applied(s,win_length,win_sep)
    cursor = 1;
    fr(1:win_length)= 0;
    fr= fr';
    count = 0;
    while(cursor < length(s))
        if(cursor+win_length-1 < length(s))
            fr(count+1,:) = s(cursor:cursor+win_length-1);
        else
            z = length(s(cursor:length(s)));
            fr(count+1,1:z) = s(cursor:length(s));
            fr(count+1,z+1:win_length) = 0;
        end;
        count = count+1;
        cursor = cursor + win_sep;
    end;
    x = fr;
endfunction;

//hamming window applied
function[x] = hamming_applied(s)
    [d,l] = size(s);
    t = [1:l]-1;
    t = t/l*2*%pi;
    ham = 0.56-0.46*cos(t);
    count = 1;
    while(count < d+1)
        x(count,:) = s(count,:).*ham;
        count = count+1; 
    end;
endfunction;

//|FFT|^2
function[x] = fft_2(s)
    [d,l] = size(s);
    x = abs(fft(s));
    x = x.*x;
    x = x(:,1:l/2);
endfunction;

//energy of a spectrum
function[x] = ener(s)
    l = length(s);
    z_i = s(1:l-1);
    z_f = s(2:l);
    z   = 0.5*(z_i + z_f);
    c(1:l-1) = 1;
    x = z*c; 
endfunction; 

// fre to mel
function[x] = f2mel(f)
    x = 1125*log(1+f/700);
endfunction;

// mel to freq
function[x] = mel2f(f)
    x = 700*(exp(f/1125)-1);
endfunction;

//Line function
function[x] = line(x1,y1,x2,y2)
    count = 1;
    point_num = x2-x1+1;
    grad = (y2-y1)/(x2-x1);
    while count < point_num+1
        x(count) = y1+grad*(count-1);
        count = count+1;
    end
    x = x';
endfunction;

//Mel filter bank
//win_length = 480
function[x] = bank(i,win_length)
    mel_cnt = 40;
    count = 1;
    x=[1:win_length/2];
    while count < mel_cnt+1
        a = i(count);
        b = i(count+1);
        c = i(count+2);
        l1 = b - a +1;
        l2 = c - b +1;
        x(count,:) = 0;
        x(count,a:b) = line(a,0,b,1);
        x(count,b:c) = line(b,1,c,0);
        count = count+1;
    end
    x = x';
endfunction;

//Normalize 
function[x] = normalize(s)
    x = s/sqrt(s*s');
endfunction;

Fs = 16000;
scale_mel = f2mel(Fs/2)/41;
//dividing equally in mel scale 
x = [0:scale_mel:scale_mel*41];
//converting it into mel scale
x = mel2f(x);
//converting it into no.of samlpe form
x = x/16000*480;
x = int(x)+1;
filter_bank = bank(x,480);

function[x] = mfcc(s)
    s_1 = preEmp(s);
    s_2 = framing_applied(s_1,480,60);
    s_3 = hamming_applied(s_2);
    [d,l] = size(s_3);
    for i = 1:d
        //fft
        s_4(i,:) = fft_2(s_3(i,:));
        mfv_100(i,:) = s_4(i,:)*filter_bank;    
        //dct
        dct_100(i,:) = dct(mfv_100(i,:));
        //1st is energy.. so dropped
        norm_100(i,:) = normalize(dct_100(i,2:14)); 
    end; 
    x = norm_100;
endfunction;

//f = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker3/dis_100.wav');
//f_1 = preEmp(f);
//f_2 = framing_applied(f_1,480,60);
//f_3 = hamming_applied(f_2);
//[d,l] = size(f_3);
//for i = 1:d
//    //fft
//    f_4(i,:) = fft_2(f_3(i,:));
//    mfv_101(i,:) = f_4(i,:)*filter_bank;    
//    //dct
//    dct_101(i,:) = dct(mfv_101(i,:));
//    norm_101(i,:) = normalize(dct_101(i,:)); 
//end;

function[x0,x1,x2,x3,x4,x5,x6,x7,x8,x9] = template_vect(speaker_no)
    count_time = 1;
    count_number = 0;
    a = ascii('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/SpeakerX/dis_XXX.wav');
    temp_name = ascii('xx');
    a(60) = speaker_no+48;
    for count_number = 0:19 
        a(67) = count_number/10 +48;
        a(68) = modulo(count_number,10)+48;
        digit_no = int(count_number/2) ;
        for count_time = 1:2
            a(66) = count_time+48;
            s = loadwave(ascii(a));
            //here i need to calculate mfcc coeff of read file
            if (count_time == 1) & (modulo(count_number,2)==0) then
                c = mfcc(s);
            else
                [d_c,l_c] = size(c);
                [d_s,l_s] = size(mfcc(s));
                c(d_c+1:d_c+d_s,:) = mfcc(s);
            end;
            //let c be coeff matrix
        end
        if modulo(count_number,2)==1 then
                if digit_no == 0 then
                    x0 = c;
                elseif digit_no == 1 then
                    x1 = c;
                elseif digit_no == 2 then
                    x2 = c;
                elseif digit_no == 3 then
                    x3 = c;
                elseif digit_no == 4 then
                    x4 = c;
                elseif digit_no == 5 then
                    x5 = c;
                elseif digit_no == 6 then
                    x6 = c;
                elseif digit_no == 7 then
                    x7 = c;
                elseif digit_no == 8 then
                    x8 = c;
                elseif digit_no == 9 then
                    x9 = c;
                end
        end;
    end;
endfunction;


function[x0,x1,x2,x3,x4,x5,x6,x7,x8,x9] = database_vect(speaker_no)
    x0(1,1:13) = 0;
    x1(1,1:13) = 0;
    x2(1,1:13) = 0;
    x3(1,1:13) = 0;
    x4(1,1:13) = 0;
    x5(1,1:13) = 0;
    x6(1,1:13) = 0;
    x7(1,1:13) = 0;
    x8(1,1:13) = 0;
    x9(1,1:13) = 0;
    for i = 1:6 
        printf("databasing begins\n");
        printf("%d",i);
        if (i ~= speaker_no) then
            [y0,y1,y2,y3,y4,y5,y6,y7,y8,y9] = template_vect(i);
            
            [d_x,l_x] = size(x0);
            [d_y,l_y] = size(y0);
            x0(d_x+1:d_x+d_y,:) = y0;
            
            [d_x,l_x] = size(x1);
            [d_y,l_y] = size(y1);
            x1(d_x+1:d_x+d_y,:) = y1;
            
            [d_x,l_x] = size(x2);
            [d_y,l_y] = size(y2);
            x2(d_x+1:d_x+d_y,:) = y2;
            
            [d_x,l_x] = size(x3);
            [d_y,l_y] = size(y3);
            x3(d_x+1:d_x+d_y,:) = y3;
            
            [d_x,l_x] = size(x4);
            [d_y,l_y] = size(y4);
            x4(d_x+1:d_x+d_y,:) = y4;
            
            [d_x,l_x] = size(x5);
            [d_y,l_y] = size(y5);
            x5(d_x+1:d_x+d_y,:) = y5;
            
            [d_x,l_x] = size(x6);
            [d_y,l_y] = size(y6);
            x6(d_x+1:d_x+d_y,:) = y6;
            
            [d_x,l_x] = size(x7);
            [d_y,l_y] = size(y7);
            x7(d_x+1:d_x+d_y,:) = y7;
            
            [d_x,l_x] = size(x8);
            [d_y,l_y] = size(y8);
            x8(d_x+1:d_x+d_y,:) = y8;
            
            [d_x,l_x] = size(x9);
            [d_y,l_y] = size(y9);
            x9(d_x+1:d_x+d_y,:) = y9;
        end;
    end
    x0 = x0(2:length(x0)/13,:);
    x1 = x1(2:length(x1)/13,:);
    x2 = x2(2:length(x2)/13,:);
    x3 = x3(2:length(x3)/13,:);
    x4 = x4(2:length(x4)/13,:);
    x5 = x5(2:length(x5)/13,:);
    x6 = x6(2:length(x6)/13,:);
    x7 = x7(2:length(x7)/13,:);
    x8 = x8(2:length(x8)/13,:);
    x9 = x9(2:length(x9)/13,:);
endfunction;


function[x] = distance(x,y)
    d = abs(x-y);
    d = d.*d;
    r(1:length(d)) = 1;
    x = sqrt(d*r);
endfunction;

//server is the dataBase
function[x] = minDist_2(temp,server)
    [d_a,l] = size(temp);
    [d_b,l] = size(server);
    for i = 1:d_a
        t = temp(i,:);
        dist = 1000000000000;
        for j = 1:d_b
             s = server(j,:);
             dist = min(dist,distance(t,s)); 
        end
        x(i,1) = dist;
    end
    x = mean(x);
endfunction;

function[Digit] = digitRecog(dig_mat,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9)
    d(1,1) = minDist_2(dig_mat,y0);
    d(1,2) = minDist_2(dig_mat,y1);
    d(1,3) = minDist_2(dig_mat,y2);
    d(1,4) = minDist_2(dig_mat,y3);
    d(1,5) = minDist_2(dig_mat,y4);
    d(1,6) = minDist_2(dig_mat,y5);
    d(1,7) = minDist_2(dig_mat,y6);
    d(1,8) = minDist_2(dig_mat,y7);
    d(1,9) = minDist_2(dig_mat,y8);
    d(1,10) = minDist_2(dig_mat,y9);
    [s,Digit] = min(d);
    Digit =Digit-1;
endfunction;

function[x] = speakRecog(speaker_no)
    [x0,x1,x2,x3,x4,x5,x6,x7,x8,x9] = template_vect(speaker_no);
    [y0,y1,y2,y3,y4,y5,y6,y7,y8,y9] = database_vect(speaker_no);
    x(1,1) = digitRecog(x0,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    x(1,2) = digitRecog(x1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    x(1,3) = digitRecog(x2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    x(1,4) = digitRecog(x3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    x(1,5) = digitRecog(x4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    x(1,6) = digitRecog(x5,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    x(1,7) = digitRecog(x6,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    x(1,8) = digitRecog(x7,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    x(1,9) = digitRecog(x8,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    x(1,10) = digitRecog(x9,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
endfunction;

function[x_0_1,x_0_2,x_0_3,x_0_4,x_1_1,x_1_2,x_1_3,x_1_4,x_2_1,x_2_2,x_2_3,x_2_4,x_3_1,x_3_2,x_3_3,x_3_4,x_4_1,x_4_2,x_4_3,x_4_4,x_5_1,x_5_2,x_5_3,x_5_4,x_6_1,x_6_2,x_6_3,x_6_4,x_7_1,x_7_2,x_7_3,x_7_4,x_8_1,x_8_2,x_8_3,x_8_4,x_9_1,x_9_2,x_9_3,x_9_4] = template_sep(speaker_no)
    a = ascii('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/SpeakerX/dis_XXX.wav');
    a(60) = speaker_no+48;
    
    for i = 1:2
        printf("i= %d\n",i);
        for j = 0:19
            printf("j = %d\n",j);
             a(66) = i+48;a(68) = modulo(j,10)+48; a(67) = int(j/10)+48;
             c = loadwave(ascii(a));
             c = mfcc(c);
             if(i == 1 ) then
                 if(j==0) then
                     x_0_1 = c;
                 elseif(j==1) then
                     x_0_2 = c;
                 elseif(j==2) then
                     x_1_1 = c;
                 elseif(j==3) then
                     x_1_2 = c;
                 elseif(j==4) then
                     x_2_1 = c;
                 elseif(j==5) then
                     x_2_2 = c;
                 elseif(j==6) then
                     x_3_1 = c;
                 elseif(j==7) then
                     x_3_2 = c;
                 elseif(j==8) then
                     x_4_1 = c;
                 elseif(j==9) then
                     x_4_2 = c;
                 elseif(j==10) then
                     x_5_1 = c;
                 elseif(j==11) then
                     x_5_2 = c;
                 elseif(j==12) then
                     x_6_1 = c;
                 elseif(j==13) then
                     x_6_2 = c;
                 elseif(j==14) then
                     x_7_1 = c;
                 elseif(j==15) then
                     x_7_2 = c;
                 elseif(j==16) then
                     x_8_1 = c;
                 elseif(j==17) then
                     x_8_2 = c;
                 elseif(j==18) then
                     x_9_1 = c;
                 elseif(j==19) then
                     x_9_2 = c;
                 end
             else
                 if(j==0) then
                     x_0_3 = c;
                 elseif(j==1) then
                     x_0_4 = c;
                 elseif(j==2) then
                     x_1_3 = c;
                 elseif(j==3) then
                     x_1_4 = c;
                 elseif(j==4) then
                     x_2_3 = c;
                 elseif(j==5) then
                     x_2_4 = c;
                 elseif(j==6) then
                     x_3_3 = c;
                 elseif(j==7) then
                     x_3_4 = c;
                 elseif(j==8) then
                     x_4_3 = c;
                 elseif(j==9) then
                     x_4_4 = c;
                 elseif(j==10) then
                     x_5_3 = c;
                 elseif(j==11) then
                     x_5_4 = c;
                 elseif(j==12) then
                     x_6_3 = c;
                 elseif(j==13) then
                     x_6_4 = c;
                 elseif(j==14) then
                     x_7_3 = c;
                 elseif(j==15) then
                     x_7_4 = c;
                 elseif(j==16) then
                     x_8_3 = c;
                 elseif(j==17) then
                     x_8_4 = c;
                 elseif(j==18) then
                     x_9_3 = c;
                 elseif(j==19) then
                     x_9_4 = c;
                 end
             end;
        end
    end
endfunction;

function[x] = speakRecog_sep(speaker_no)
    [x_0_1,x_0_2,x_0_3,x_0_4,x_1_1,x_1_2,x_1_3,x_1_4,x_2_1,x_2_2,x_2_3,x_2_4,x_3_1,x_3_2,x_3_3,x_3_4,x_4_1,x_4_2,x_4_3,x_4_4,x_5_1,x_5_2,x_5_3,x_5_4,x_6_1,x_6_2,x_6_3,x_6_4,x_7_1,x_7_2,x_7_3,x_7_4,x_8_1,x_8_2,x_8_3,x_8_4,x_9_1,x_9_2,x_9_3,x_9_4] = template_sep(speaker_no);
    [y0,y1,y2,y3,y4,y5,y6,y7,y8,y9] = database_vect(speaker_no);
//    
//    y0 = CMeans(y0,y0(1:100,:),2,'iterations',10);
//    y1 = CMeans(y1,y1(1:100,:),2,'iterations',10);
//    y2 = CMeans(y2,y2(1:100,:),2,'iterations',10);
//    y3 = CMeans(y3,y3(1:100,:),2,'iterations',10);
//    y4 = CMeans(y4,y4(1:100,:),2,'iterations',10);
//    y5 = CMeans(y5,y5(1:100,:),2,'iterations',10);
//    y6 = CMeans(y6,y6(1:100,:),2,'iterations',10);
//    y7 = CMeans(y7,y7(1:100,:),2,'iterations',10);
//    y8 = CMeans(y8,y8(1:100,:),2,'iterations',10);
//    y9 = CMeans(y9,y9(1:100,:),2,'iterations',10);

    [model,y] = nan_kmeans(y0,4*4);
    y0 = model.X;
    [model,y] = nan_kmeans(y1,3*4);
    y1 = model.X;
    [model,y] = nan_kmeans(y2,2*4);
    y2 = model.X;
    [model,y] = nan_kmeans(y3,3*4);
    y3 = model.X;
    [model,y] = nan_kmeans(y4,3*4);
    y4 = model.X;
    [model,y] = nan_kmeans(y5,3*4);
    y5 = model.X;
    [model,y] = nan_kmeans(y6,6*4);
    y6 = model.X;
    [model,y] = nan_kmeans(y7,7*4);
    y7 = model.X;
    [model,y] = nan_kmeans(y8,2*4);
    y8 = model.X;
    [model,y] = nan_kmeans(y9,3*4);
    y9 = model.X;
    
    printf("1st time\n");
    
    printf("0 processing\n");x(1,1) = digitRecog(x_0_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("1 processing\n");x(1,2) = digitRecog(x_1_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("2 processing\n");x(1,3) = digitRecog(x_2_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("3 processing\n");x(1,4) = digitRecog(x_3_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("4 processing\n");x(1,5) = digitRecog(x_4_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("5 processing\n");x(1,6) = digitRecog(x_5_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("6 processing\n");x(1,7) = digitRecog(x_6_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("7 processing\n");x(1,8) = digitRecog(x_7_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("8 processing\n");x(1,9) = digitRecog(x_8_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("9 processing\n");x(1,10) = digitRecog(x_9_1,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    
    printf("2st time\n");
    
    printf("0 processing\n");x(2,1) = digitRecog(x_0_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("1 processing\n");x(2,2) = digitRecog(x_1_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("2 processing\n");x(2,3) = digitRecog(x_2_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("3 processing\n");x(2,4) = digitRecog(x_3_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("4 processing\n");x(2,5) = digitRecog(x_4_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("5 processing\n");x(2,6) = digitRecog(x_5_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("6 processing\n");x(2,7) = digitRecog(x_6_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("7 processing\n");x(2,8) = digitRecog(x_7_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("8 processing\n");x(2,9) = digitRecog(x_8_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("9 processing\n");x(2,10) = digitRecog(x_9_2,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    
    printf("3st time\n");
    printf("0 processing\n");x(3,1) = digitRecog(x_0_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("1 processing\n");x(3,2) = digitRecog(x_1_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("2 processing\n");x(3,3) = digitRecog(x_2_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("3 processing\n");x(3,4) = digitRecog(x_3_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("4 processing\n");x(3,5) = digitRecog(x_4_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("5 processing\n");x(3,6) = digitRecog(x_5_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("6 processing\n");x(3,7) = digitRecog(x_6_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("7 processing\n");x(3,8) = digitRecog(x_7_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("8 processing\n");x(3,9) = digitRecog(x_8_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("9 processing\n");x(3,10) = digitRecog(x_9_3,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    
    printf("4st time\n");
    printf("0 processing\n");x(4,1) = digitRecog(x_0_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("1 processing\n");x(4,2) = digitRecog(x_1_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("2 processing\n");x(4,3) = digitRecog(x_2_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("3 processing\n");x(4,4) = digitRecog(x_3_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("4 processing\n");x(4,5) = digitRecog(x_4_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("5 processing\n");x(4,6) = digitRecog(x_5_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("6 processing\n");x(4,7) = digitRecog(x_6_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("7 processing\n");x(4,8) = digitRecog(x_7_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("8 processing\n");x(4,9) = digitRecog(x_8_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    printf("9 processing\n");x(4,10) = digitRecog(x_9_4,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9);
    
endfunction;
