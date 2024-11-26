import os
os.chdir(os.path.dirname(__file__))

with open('demo_output_data.txt', 'r', encoding='utf8') as f:
    data = f.read().split('\n')

main_key = 'PC'
columns = []
for line in data:
    if not line:
        continue
    key, value = line.split(' = ')
    if key not in columns:
        columns.append(key)
print('columns:',columns)

table = []
for line in data:
    if not line:
        continue
    key, value = line.split(' = ')
    if key == main_key:
        table.append([''] * len(columns))
    index = columns.index(key)
    table[-1][index] = value

with open('demo_output_data.typ', 'w', encoding='utf8') as f:
    f.write('#{\n')
    f.write('set text(font: "Consolas")\n')
    f.write('table(\n')
    f.write(f'columns: ({', '.join(['1fr'] * len(columns))}),\n')
    f.write('align: center + horizon,\n')
    for key in columns:
        f.write(f'[*{key}*], ')
    f.write('\n')
    for row in table:
        for value in row:
            f.write(f'[{value.upper()}], ')
        f.write('\n')
    f.write(')\n')
    f.write('}\n')