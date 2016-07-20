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
        //im converting the signal into rectangular pulses so that the blank space can be removed by differentiation (almost constant so derivative nearly zero) 
        x(cursor:cursor+scale-1) = inter_sum/scale;
        cursor = cursor + scale;
    end
    x = x';    
endfunction

function[x,t] = dissect(s,scale_diff, scale_avg,file_no,index)
    s_avg = avg_func(s,scale_avg);
    diff_s = diff(s_avg);
    cursor = 1;
    last_state = 0;
    nstate = 0;
    z= [0];
    count = 0;
    while(cursor + scale_diff - 1 < length(diff_s)) 
        r = max(diff_s(cursor:cursor+scale_diff-1));
        if r > 0.00004 then
            len = length(z);
            z(len+1:len + scale_diff) = s(cursor:cursor+scale_diff-1);
            nstate = 1;
            last_state = 1;
        else
            nstate = 0;
                if last_state > nstate then
                    last_state = nstate;
                    //naming the files
                    a = ascii('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/SpeakerX/dis_XXX.wav')
                    a(68) = modulo(count,10)+48;
                    a(67) = modulo(int(count/10),10)+48;
                    a(66) = index + 48;
                    a(60) = file_no+48;
                    if(length(z)>3000) then
                       wavwrite(z,16000,ascii(a));
                       count = count+1;
                    end
                    z = [0];   
                end
        end
        cursor = cursor + scale_diff;
        if cursor > length(diff_s)- scale_diff then
            a = ascii('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/SpeakerX/dis_XXX.wav')
            a(68) = modulo(count,10)+48;
            a(67) = modulo(int(count/10),10)+48;
            a(66) = index + 48;
            a(60) = file_no+48;
            if(length(z)>3000) then
               wavwrite(z,16000,ascii(a));
               count = count+1;
            end;
        end;
        t = cursor
    end
    x = z;
endfunction

//this functon is just for my comfort 
function[] = file_gen(scale_diff,scale_avg,file_no)
    b = ascii('/home/achyutha/Music/PROJECT_Voice/Files/Recordings/SpeakerX/X.wav');
    i = 1;
    b(60)  = file_no + 48;
    while i<3
        b(62) = i + 48;
        s = loadwave(ascii(b));
        dissect(s,scale_diff, scale_avg,file_no,i);
        i = i+1;
    end
endfunction 

//This loop dissects all the 12 sounds into 0-9's
i = 1;
while i<7
    file_gen(2000,100,i);
    i = i+1;
    i
end
