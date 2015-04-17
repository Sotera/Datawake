"""

Copyright 2014 Sotera Defense Solutions, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

"""

import json

import sys
import urllib
import urllib2
from kafka import SimpleProducer, KafkaClient
import json
from datetime import datetime, timedelta
from time import mktime, sleep
import tangelo
import requests
from datawake.util.validate.parameters import required_parameters

"""

 Returns hour record counts.   Used to display the date time filter bar graph on the forensic view/

"""

httpSession = requests.Session()


def restGet(hostname, port, route, query_string=''):
    try:
        url = 'http://' + hostname + ':' + str(port) + '/' + route
        if len(query_string) > 0:
            url += '?' + query_string
        res = httpSession.get(url)
        return str(res.text)
    except:
        print sys.exc_info()[0]


def getAddressLatLon(streetAddress):
    # streetAddress = '1600 Pennsylvania Ave, Washington, DC'
    streetAddressQueryString = 'address=' + urllib.quote_plus(streetAddress)
    hostname = 'geocoder.us'
    route = '/service/csv'
    addressResultArray = restGet(hostname, 80, route, streetAddressQueryString).split(',')
    geolocatedLatLon = dict(lat=addressResultArray[0], lon=addressResultArray[1], streetAddress=addressResultArray[2],
                            city=addressResultArray[3], state=addressResultArray[4], zip=addressResultArray[5])
    return geolocatedLatLon


def doInstagramMagic(address, client_id, start_date, end_date, lat, lon, radiusMeters):
    time_inc_seconds = 3600  # one hour is what we'll start with

    tmp_start_date = start_date
    tmp_end_date = start_date + timedelta(seconds=time_inc_seconds)  # set this to start + the time increment

    while tmp_start_date < end_date:
        response = None
        try:
            # make the call to instagram
            response = urllib2.urlopen('https://api.instagram.com/v1/media/search?distance='
                                       + str(radiusMeters) + '&'
                                       + 'min_timestamp=' + str(int(mktime(tmp_start_date.timetuple()))) + '&'
                                       + 'max_timestamp=' + str(int(mktime(tmp_end_date.timetuple()))) + '&'
                                       + 'lat=' + str(lat) + '&'
                                       + 'lng=' + str(lon) + '&client_id=' + client_id
                                       + '&count=500')
        # weird error? just sleep for a second, print the error, and move on to the next time slice.
        except urllib2.URLError:
            sleep(1)
            continue

        # if we get here we have some results
        html = response.read()

        responseObject = lambda: None
        responseObject.__dict__ = json.loads(html)
        # imgData = j['data']
        # imgCount = len(imgData)
        # imgCount = imgCount if (imgCount < 10) else 10

        # for i in range(0,imgCount - 1):
        # img = imgData[i]

        count = len(responseObject.data)  # count the number of images.

        try:
            responseObject.resolvedAddress = address.streetAddress + ', ' + address.city + ', ' + address.state
        except:
            responseObject.resolvedAddress = u'No Address'

        responseObject.latitude = str(lat)
        responseObject.longitude = str(lon)
        responseObject.radiusInMeters = str(radiusMeters)

        json_dumps = (json.dumps(responseObject.__dict__), count)
        return json_dumps

        sleep(1)  # this sleep call ensures we don't hit instagram's api limit of 5000 an hour.
        tmp_start_date = tmp_end_date  # make the start time equal to the previous end.
        tmp_end_date = tmp_end_date + timedelta(seconds=time_inc_seconds)


@tangelo.restful
# @required_parameters(['address'])
def get(address=u'', lat=0, lon=0, radius=0):
    # streetAddress = '1600 Pennsylvania Ave, Washington, DC'
    client_id = '8728ec7ee9424eb4aae9d45107ee6481'

    resolvedAddress = lambda: None

    if len(address) > 0:
        resolvedAddress.__dict__ = getAddressLatLon(address)
        lat = float(resolvedAddress.lat)
        lon = float(resolvedAddress.lon)
        radius = 5000

    now = datetime.now()
    sixHoursEarlier = now - timedelta(hours=1)
    instagramReturnTuple = doInstagramMagic(resolvedAddress, client_id, sixHoursEarlier, now, lat, lon, radius)
    instagramJson = instagramReturnTuple[0]
    resolvedAddress.imageCount = instagramReturnTuple[1]

    topic = 'qpr.geogram'
    host = 'k01.istresearch.com'
    port = 9092

    kafka = KafkaClient("%s:%i" % (host, port))
    producer = SimpleProducer(kafka)

    message = json.dumps({"message": instagramJson})

    producer.send_messages(topic, message)

    return json.dumps(resolvedAddress.__dict__)


