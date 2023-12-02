#!/bin/bash -x

mkdir day-$1
cd day-$1

touch .gitignore
touch in
touch input
cat > README.md <<END
Install 

Run:
\`\`\`
./
\`\`\`
END
