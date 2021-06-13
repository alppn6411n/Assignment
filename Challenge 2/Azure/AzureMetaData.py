import requests


def get_meta_data_for_Azure(meta_url):
    """
    This function fetches metadata for Azure.

    :param meta_url: Azure URL to fetch metadata.
    :return: json structure with meta data.
    """

    headers = {"Metadata": "true"}
    response_json = requests.get(meta_url, headers=headers).json()

    return response_json


metaurl = 'http://169.254.169.254/metadata/instance?api-version=2021-02-01'

try:
    with open("azure_metadata.json", "w+") as file:
        file.write(get_meta_data_for_Azure(metaurl))
except:
    print("Error while fetching meta-data !")
