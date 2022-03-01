from prometheus_client import Gauge, start_http_server
import requests
import time

URL_RESPONSE = Gauge('sample_external_url_response_ms', 'Description of summary', ['url'])
URL_UP = Gauge('sample_external_url_up', 'Description of gauge', ['url'])

LIST_URL = ["https://httpstat.us/200","https://httpstat.us/503"]

def crawl_url(url):
    try:
        response = requests.get(url)
        URL_RESPONSE.labels(url).set(response.elapsed.total_seconds()*1000)
        if response.status_code == 200:
            URL_UP.labels(url).set(1)
        else:
            URL_UP.labels(url).set(0)
    except Exception as e: 
        print(e)
        return
    return response.status_code


if __name__ == '__main__':
    start_http_server(8000)

    while True:
        for each_url in LIST_URL:
            response_code = crawl_url(each_url)
            print("Response code for " + str(each_url) + " : " + str(response_code))
            time.sleep(1)