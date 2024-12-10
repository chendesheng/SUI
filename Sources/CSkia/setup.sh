# replace `#include "include/c/` with `#include "`
sed -i '' 's/#include "include\/c\//#include "/g' include/*.h