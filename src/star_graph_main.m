clc; 
clear; 
close all;

message = upper(input('Enter your message: ', 's'));
k = input('Enter key value (2-13): ');
fprintf('Message: %s\n', message);
fprintf('Key (k): %d\n\n', k);

fprintf('========================================\n');
fprintf('STEP 1: CALCULATE n AND SELECT PRIMES\n');
fprintf('========================================\n\n');

n = ceil(26/k) + k;
fprintf('n = ceil(26/k) + k\n');
fprintf('n = ceil(26/%d) + %d\n', k, k);
fprintf('n = ceil(%.2f) + %d\n', 26/k, k);
fprintf('n = %d + %d = %d\n\n', ceil(26/k), k, n);

all_primes = primes(50);
prime_set = all_primes(1:n);

num_rows = n - k;
num_cols = k;
fprintf('Number of rows = n - k = %d - %d = %d\n', n, k, num_rows);
fprintf('Number of columns = k = %d\n\n', num_cols);

col_primes = prime_set(1:num_cols);
row_primes = prime_set(num_cols+1:n);
fprintf('Column Primes (first %d primes): ', num_cols);
fprintf('%d ', col_primes);
fprintf('\n');

fprintf('Row Primes (next %d primes): ', num_rows);
fprintf('%d ', row_primes);
fprintf('\n\n');

fprintf('========================================\n');
fprintf('STEP 2: CREATE ENCODING TABLE\n');
fprintf('========================================\n\n');

alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
total_cells = num_rows * num_cols;
padding = total_cells - 26;

fprintf('Total cells = %d × %d = %d\n', num_rows, num_cols, total_cells);
fprintf('Padding required = %d - 26 = %d\n\n', total_cells, padding);

letter_grid = reshape([alphabet, blanks(padding)], num_cols, num_rows)';
encoding_table = cell(num_rows, num_cols);

for row = 1:num_rows
    for col = 1:num_cols
        encoding_table{row, col} = letter_grid(row, col);
    end
end

fprintf('Encoding Table:\n\n');

fprintf('    |');
for col = 1:num_cols
    fprintf('  %-4d |', col_primes(col));
end
fprintf('\n');

for row = 1:num_rows
    fprintf('| %-2d|', row_primes(row));
    for col = 1:num_cols
        letter = char(encoding_table{row, col});
        if letter == ' '
            fprintf('   -   |');
        else
            fprintf('   %-4s|', letter);
        end
    end
    fprintf('\n');
end
fprintf('\n');

fprintf('========================================\n');
fprintf('STEP 3: ENCRYPTION PROCESS\n');
fprintf('========================================\n\n');

msg_len = length(message);
vertex_labels = zeros(1, msg_len);

fprintf('Character-by-Character Encryption:\n\n');

for i = 1:msg_len
    letter = message(i);
    found = false;
    
    for row = 1:num_rows
        for col = 1:num_cols
            if strcmpi(char(encoding_table{row, col}), letter)
                vertex_labels(i) = row_primes(row) * col_primes(col);
                
                fprintf('Position %d: Letter "%s"\n', i, letter);
                fprintf('  → Found at Row %d, Column %d\n', row, col);
                fprintf('  → Row Prime = %d, Column Prime = %d\n', ...
                    row_primes(row), col_primes(col));
                fprintf('  → Vertex Label = %d × %d = %d\n', ...
                    row_primes(row), col_primes(col), vertex_labels(i));
                
                found = true;
                break;
            end
        end
        if found
            break;
        end
    end
    
    if ~found
        row = mod(i-1, num_rows) + 1;
        col = mod(i-1, num_cols) + 1;
        vertex_labels(i) = row_primes(row) * col_primes(col);
        
        fprintf('Position %d: Special character "%s"\n', i, letter);
        fprintf('  → Mapped to Row %d, Column %d\n', row, col);
        fprintf('  → Vertex Label = %d × %d = %d\n', ...
            row_primes(row), col_primes(col), vertex_labels(i));
    end
    fprintf('\n');
end


edge_weights = zeros(1, msg_len);

fprintf('Edge Weight Calculation:\n\n');
for i = 1:msg_len
    edge_weights(i) = vertex_labels(i) - 10^i;
    fprintf('Edge %d: Weight = Vertex Label - 10^%d\n', i, i);
    fprintf('       = %d - %d = %d\n\n', vertex_labels(i), 10^i, edge_weights(i));
end

fprintf('ENCRYPTED MESSAGE (Edge Weights): ');
fprintf('%d ', edge_weights);
fprintf('\n\n');

figure('Color', 'w', 'Position', [200 100 900 800]);
angles = linspace(0, 2*pi, msg_len+1);
angles = angles(1:end-1);
radius = 3;
x_pos = radius * cos(angles);
y_pos = radius * sin(angles);
hold on;

for i = 1:msg_len
    plot([0, x_pos(i)], [0, y_pos(i)], 'k-', 'LineWidth', 2.5);
    mid_x = x_pos(i) * 0.65;
    mid_y = y_pos(i) * 0.65;
    text(mid_x, mid_y, sprintf('%d', edge_weights(i)), 'FontSize', 11, ...
        'FontWeight', 'bold', 'BackgroundColor', 'white');
end

rectangle('Position', [-0.35, -0.35, 0.7, 0.7], 'Curvature', [1 1], ...
    'FaceColor', 'w', 'EdgeColor', 'k', 'LineWidth', 3);
text(0, 0, '0', 'FontSize', 18, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center');

for i = 1:msg_len
    rectangle('Position', [x_pos(i)-0.35, y_pos(i)-0.35, 0.7, 0.7], ...
        'Curvature', [1 1], 'FaceColor', 'w', 'EdgeColor', 'k', 'LineWidth', 3);
    text(x_pos(i), y_pos(i), sprintf('%d', vertex_labels(i)), 'FontSize', 14, ...
        'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

axis equal off;
xlim([-4.5 4.5]);
ylim([-4.5 4.5]);
text(0, -4.2, 'Encrypted message to be sent.', 'FontSize', 12, ...
    'HorizontalAlignment', 'center');
hold off;

fprintf('========================================\n');
fprintf('STEP 4: DECRYPTION PROCESS\n');
fprintf('========================================\n\n');

decoded_message = '';

for i = 1:msg_len
    recovered_vertex = edge_weights(i) + 10^i;
    fprintf('Edge %d: Weight = %d\n', i, edge_weights(i));
    fprintf('  → Add 10^%d: %d + %d = %d\n', i, edge_weights(i), 10^i, recovered_vertex);

    found = false;
    for row = 1:num_rows
        for col = 1:num_cols
            if row_primes(row) * col_primes(col) == recovered_vertex
                letter = char(encoding_table{row, col});
                decoded_message = [decoded_message, letter];
                fprintf('  → Vertex %d = %d × %d (Row %d, Col %d)\n', ...
                    recovered_vertex, row_primes(row), col_primes(col), row, col);
                fprintf('  → Decrypted Letter: "%s"\n\n', letter);
                found = true;
                break;
            end
        end
        if found
            break;
        end
    end
    
    if ~found
        decoded_message = [decoded_message, '?'];
        fprintf('  → Letter: "?" (not found)\n\n');
    end
end

fprintf('Original Message:  %s\n', message);
fprintf('Decrypted Message: %s\n\n', decoded_message);