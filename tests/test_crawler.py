
from src.app import crawl_url
import unittest

class TestHttpCrawler(unittest.TestCase):
    def test_http_crawler_200_success(self):
        actual = crawl_url("https://httpstat.us/200")
        expected = 200
        self.assertEqual(actual, expected, "FAILURE")

    def test_http_crawler_503_success(self):
        actual = crawl_url("https://httpstat.us/503")
        expected = 503
        self.assertEqual(actual, expected, "FAILURE")

    def test_http_crawler_200_failure(self):
        actual = crawl_url("https://httpstat.us/200")
        expected = 503
        self.assertNotEqual(actual, expected, "FAILURE")

    def test_http_crawler_503_failure(self):
        actual = crawl_url("https://httpstat.us/503")
        expected = 200
        self.assertNotEqual(actual, expected, "FAILURE")