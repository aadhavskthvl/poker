from selenium import webdriver
import requests
import os

def download_images(url):
    driver = webdriver.Firefox()  # or webdriver.Chrome()
    driver.get(url)

    if not os.path.exists('images'):
        os.makedirs('images')

    img_elements = driver.find_elements_by_tag_name('img')

    for img in img_elements:
        img_url = img.get_attribute('src')
        if img_url is not None:
            response = requests.get(img_url)
            with open('images/'+os.path.basename(img_url), 'wb') as f:
                f.write(response.content)

    driver.quit()

download_images('https://www.flaticon.com/packs/playing-cards-18')

