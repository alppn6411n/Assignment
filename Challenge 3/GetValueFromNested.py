import json


def get_val_from_nested_object(in_obj, keys):
    """
    This method can be used to extract values for the specified keys from the given nested object.

    :param in_obj: Input Json/dictionary from which the value is to be extracted
    :param keys: key or "/" seperated list of keys for which the value is to be fetched
    :return: The value of given keys from the in_obj in case of success. In case of failure, return "ERROR".
    """

    # Initialize variables
    list_of_keys = keys.split("/")
    temp = {}

    # Loop to get the values for all the keys in a given list sequentially
    for key in list_of_keys:

        if key == "":
            print(f"[ERROR] : Blank key encountered in the input chain.")
            return "ERROR"

        try:
            # Only for the first time
            if len(temp) == 0:
                temp = in_obj[key]

            else:
                temp = temp[key]

        except KeyError:
            # In case invalid / inexistent key is provided
            print(f"[ERROR] :: No data found for input key '{keys}'")
            return "ERROR"

    return temp


# Test Driver starts here
with open("tests.txt", "r") as f:
    tests = f.readlines()

for test in tests:
    details = test.split(" : ")

    with open(details[0], "r") as input_file:
        input_object = json.loads(input_file.read())

    test_description = details[2].strip("\n")
    print("====================================")
    print(f"[TEST] : {test_description}")
    print(f"INPUT FILE - {details[0]}")
    print(f"KEY - {details[1]}")

    result = get_val_from_nested_object(input_object, details[1])

    if result != "ERROR":
        print(f"[SUCCESS] : VALUE - {result}")
