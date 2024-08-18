#!/bin/bash

# Prompt the user for the program name
read -p "Enter the program name: " program_name

# Prompt the user for the source files
read -p "Enter the source files (space-separated, excluding \`main.cpp\`): " source_files
read -p "Would you like to create header-files associated with the source files? (y/n): " answer
read -p "Would you like to create a main.cpp file (with simple boiler-plate)? [y/n]: " main_answer

INCLUDES=""

if [ "$answer" == "y" ]; then
	for file in $source_files; do
        header_file="${file%.cpp}.hpp"
        touch "$header_file"
    done
	INCLUDES+="INCLUDES := \$(SRC:.cpp=.hpp)";
fi

if [ "$main_answer" == "y" ]; then
	source_files+=" main.cpp"
fi

# Create the source_files
touch $source_files

# Create the Makefile
cat <<EOL > Makefile
# Program
NAME := $program_name

# Necessities
CXX := c++
CXXFLAGS := -Wall -Wextra -Werror -std=c++98

# Targets
SRC := $source_files
$INCLUDES

# Rules
all: \$(NAME)

\$(NAME): \$(SRC)
	\$(CXX) -o \$@ \$(CXXFLAGS) \$(SRC)

clean:
	rm -rf \$(NAME)

re: clean all
EOL

echo "Makefile generated successfully."


if [ "$main_answer" == "y" ]; then
	cat<<EOF > main.cpp
#include <iostream>

int main(void) {
	std::cout << "Hello, world!" << std::endl;

	return 0;
}

EOF
fi

