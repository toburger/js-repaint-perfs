# install elm
npm install -g elm

# compile Naive implementation
elm make Main.elm --output main.js --yes

# compile Optimized implementation
elm make Opt.elm --output opt.js --yes
