function [lines] = applyOrder(data, in_order)

[row, ded] = size(in_order);
[ded, col] = size(data);

lines = cell(1, col);
count = 1;
block = 1;

for i = 1:row
    
    for j = 1:col-1
        if data{j}{1} == in_order(i, 1)
            lines{count} = data{j};
            lines{count}{1} = block;
            count = count + 1;
        end
    end
    
    block = block + 1;
end % End for loop

lines{col} = data{col};
% 
% for i = 1:col
%     disp(lines{i});
% end



end % End of function 'applyOrder'