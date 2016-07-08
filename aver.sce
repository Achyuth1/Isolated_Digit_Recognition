//Fc = 16000

s_1_1 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker1/1.wav');
s_1_2 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker1/2.wav');

s_2_1 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker2/1.wav');
s_2_2 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker2/2.wav');

s_3_1 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker3/1.wav');
s_3_2 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker3/2.wav');

s_4_1 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker4/1.wav');
s_4_2 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker4/2.wav');

s_5_1 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker5/1.wav');
s_5_2 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker5/2.wav');

s_6_1 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker6/1.wav');
s_6_2 = loadwave('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker6/2.wav');


function[x] = avg_func(s,scale)
    c = abs(s);
    cursor= 1;
    while(cursor+scale-1<length(c))
        count_cursor = 0;
        inter_sum = 0;
        //while loop of averaging begins
        if(cursor == 1) then
            while count_cursor < scale
                inter_sum = inter_sum+c(cursor+count_cursor);
                count_cursor = count_cursor+1;
            end
        else
            inter_sum = x(cursor-1)*scale - c(cursor-1)+c(cursor+scale-1);
        end
        x(cursor:cursor+scale-1) = inter_sum/scale;
        cursor = cursor + scale;
    end
    x = x';    
endfunction

function[x,t] = dissect(s,scale_diff, scale_avg)
    s_avg = avg_func(s,scale_avg);
    diff_s = diff(s_avg);
    cursor = 1;
    z= [0];
    while(cursor + scale_diff - 1 < length(diff_s)) 
        r = max(diff_s(cursor:cursor+scale_diff-1));
        if r > 0.00004 then
            len = length(z);
            z(len+1:len + scale_diff) = s(cursor:cursor+scale_diff-1);
        end
        cursor = cursor + scale_diff;
        t = cursor;
    end
    x = z;
endfunction


wavwrite(dissect(s_1_1,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker1/1_dis.wav');
wavwrite(dissect(s_1_2,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker1/2_dis.wav');

wavwrite(dissect(s_2_1,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker2/1_dis.wav');
wavwrite(dissect(s_2_2,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker2/2_dis.wav');

wavwrite(dissect(s_3_1,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker3/1_dis.wav');
wavwrite(dissect(s_3_2,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker3/2_dis.wav');

wavwrite(dissect(s_4_1,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker4/1_dis.wav');
wavwrite(dissect(s_4_2,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker4/2_dis.wav');

wavwrite(dissect(s_5_1,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker5/1_dis.wav');
wavwrite(dissect(s_5_2,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker5/2_dis.wav');

wavwrite(dissect(s_6_1,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker6/1_dis.wav');
wavwrite(dissect(s_6_2,2000,100),16000,'/home/achyutha/Music/PROJECT_Voice/Files/Recordings/Speaker6/2_dis.wav');





