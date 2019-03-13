if rel_ang <= 0
    if rel_ang >= -180
        
        if (prev_servo + rel_ang) >= 0
           servo_rot = prev_servo + rel_ang
           %s20
        else  
            servo_rot = prev_servo + 180 + rel_ang
            %s-20
        end
        
    else
        rel_ang_1 = 360 + rel_ang 
       
        if (prev_servo + rel_ang_1) <= 180
            servo_rot = prev_servo + rel_ang_1
            %s20
        else
            servo_rot = prev_servo - 180 + rel_ang_1
            %s-20
        end    
    end     
end

if rel_ang > 0
    
    if rel_ang <= 180
        
        if rel_ang + prev_servo <= 180
            servo_rot = prev_servo + rel_ang
            %s20
        else
            servo_rot = prev_servo + rel_ang - 180
            %s-20
        end
        
    else
        rel_ang_1 = 360 - rel_ang
        
        if prev_servo - rel_ang_1 >= 0
            servo_rot = prev_servo - rel_ang_1
            %s20
        else
            servo_rot = prev_servo + 180 - rel_ang_1
        end    
    end    
end
