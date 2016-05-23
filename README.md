# Coding Challenge 3 Solution

This is a solution to **Coding Challenge 3** from: https://wiki.willowtreeapps.com/display/iOS/Coding+Challenges

> A certain computer has ten registers and 1,000 words of RAM. Each register or RAM location holds a three-digit integer between 0 and 999. Instructions are encoded as three-digit integers and stored in RAM. The encodings are as follows:
- 100 means halt
- 2dn	set register d to n (between 0 and 9)
- 3dn	add n to register d
- 4dn	multiply register d by n
- 5ds	set register d to the value of register s
- 6ds	add the value of register s to register d
- 7ds	multiply register d by the value of register s
- 8da	set register d to the value in RAM whose address is in register a
- 9sa	set the value in RAM whose address in in register a to that of register s
- 0ds	goto the location in register d unless register s contains 0

> All registers initially contain 000. The initial contents of RAM is read from standard input. The first instruction to be executed is at RAM address 0. All results are reduced modulo 1,000
Write a program that takes in up to 1,000 three-digit unsigned integers, representing the contents of consecutive RAM locations starting at 0. Input will end with a blank line. Unspecified RAM locations are initialized to 000.
Output should be a single integer which is the number of instructions executed up to and including the halt instruction. You may assume that the program does halt.
Bonus (maybe): Output the values in each of the 10 registers on program completion.
