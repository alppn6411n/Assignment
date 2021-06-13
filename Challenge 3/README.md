# Challenge3

## Objective
A python code that accepts json(nested) and key and outputs the value.

## Requirements
python3 (no extra libraries required)

## Usage
```
python3 GetValueFromNested.py
```

## Sample Output
```
$ python3 GetValueFromNested.py
====================================
[TEST] : Positive Case With valid details
INPUT FILE - nested_json.txt
KEY - emp1/EmpAge/EmpGender/EmpDesg
[SUCCESS] : VALUE - Team Leader
====================================
[TEST] : Positive Case with valid details
INPUT FILE - nested_json.txt
KEY - emp2/EmpDept
[SUCCESS] : VALUE - IT
====================================
[TEST] : Positive Case with valid single key without "/"
INPUT FILE - nested_json.txt
KEY - emp3
[SUCCESS] : VALUE - Peter Parker
====================================
[TEST] : Negative case where "/" is input twice in the key
INPUT FILE - nested_json.txt
KEY - emp2//EmpDept
[ERROR] : Blank key encountered in the input chain.
====================================
[TEST] : Negative case where one of the keys in the chain does not exist
INPUT FILE - nested_json.txt
KEY - emp1/EmpAge/EmpGend/EmpDesg
[ERROR] :: No data found for input key 'emp1/EmpAge/EmpGend/EmpDesg'
====================================
[TEST] : Blank value for key is provided
INPUT FILE - nested_json.txt
KEY - 
[ERROR] : Blank key encountered in the input chain.

Process finished with exit code 0
```
