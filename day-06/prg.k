pos: {x _ss " [^ ]"}
dlb: {x@&|\~x=" "}
dtb: {|dlb@|x}
trim: {dlb dtb x}
parseLine: {0$/: trim/: ((pos x) _ x)}
ceil: {1 - (_ (1 - x))}
det: {-0.0001 + _sqrt ((x*x)-(4*y))}
x1: {_ (x + det[x;y]) % 2}
x2: {ceil (x - det[x;y]) % 2}
wins: {1 + (x1[x;y]) - (x2[x;y])}
tail: {*(x _ss "[0-9]")}
parseLine2: {0$ _ssr[(tail x) _ x;" ";""]}

in: 0: _a@2
t: parseLine[in@0]
d: parseLine[in@1]
*/wins[t;d]

t2: parseLine2[in@0];
d2: parseLine2[in@1];
wins[t2;d2]

\\
