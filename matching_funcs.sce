exec('/home/achyutha/Music/PROJECT_Voice/main.sce', -1);
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

