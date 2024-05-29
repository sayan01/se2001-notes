#!/bin/bash
if [[ ! -f ../script.sh ]]; then
  echo "script.sh not found"
  exit 1
fi

if [[ ! -x ../script.sh ]]; then
  echo "script.sh is not executable"
  exit 1
fi

for _ in {1..100}; do # template
  ran1=$((RANDOM%10+1))
  ran2=$((RANDOM%10+1))
  tr -dc 'A-Z' < /dev/urandom | head -c "$ran1"
  printf "_"
  tr -dc 'a-z' < /dev/urandom | head -c "$ran2"
  echo
done | shuf | split -n l/10 --additional-suffix=.in -d

rm test_case_* -rf

for input in *.in; do
  number=${input%.in}
  number=${number#x0}
  test_case="test_case_$number"
  mkdir -p "$test_case"
  mv "$input" "$test_case/input.txt" -f
  ../script.sh < "$test_case/input.txt" > "$test_case/output.txt"
done

find . -type d -name 'test_case_*' | sort | sed "s/^\./$(basename "$PWD")/" > ../private_test_cases.txt
