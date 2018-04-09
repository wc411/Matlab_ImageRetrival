function [result] = hist_sect(h1,h2)
    [row,~] = size(h1);
    
    minimum = 1:row;
    for i = 1 : row
        minimum(i) = min(h1(i),h2(i));
    end
    
    result = sum(minimum) / sum(h2);
end