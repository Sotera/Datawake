import threading
from extract_email import ExtractEmail
from extract_phonenumber import ExtractPhoneNumber
from extract_website import ExtractWebsite
from extract_info import ExtractInfo
import traceback

class ExtractorThread(threading.Thread):
    def __init__(self, extractor,data,lock):
        threading.Thread.__init__(self)
        self.extractor = extractor
        self.data = data
        self.lock = lock

    def run(self):
        name = self.extractor.name()
        results = []

        try:
            features = self.extractor.extract('', '', '', '', self.data['content'], '', '')
            for feature in features:
                results.append(feature.value)

            if name == 'info':
                # special case for MITIE, split each MITIE group into its own category
                mitie_dict = {}
                for result in results:
                    (mitie_name,value) = result.split("->")
                    mitie_name = mitie_name.strip()
                    value = value.strip()
                    if mitie_name not in mitie_dict:
                        mitie_dict[mitie_name] = []
                    mitie_dict[mitie_name].append(value)

                    self.lock.acquire()
                    for key,value in mitie_dict.iteritems():
                        self.data['features'][key] = value
                    self.lock.release()

            else:
                self.lock.acquire()
                self.data['features'][name] = results
                self.lock.release()
        except:
            self.lock.acquire()
            self.data['errors'].append(traceback.format_exc())
            self.lock.release()





def extractAll(content):
    """
    Process content and returns extracted features.
    :param content: text content
    :return: ({'feature_name':[value,..]} , [error mesage,..]  )
    """
    threads = []
    lock = threading.Lock()
    data = {'content':content, 'errors':[], 'features':{}}
    threads.append(ExtractorThread(ExtractEmail(),data,lock))
    threads.append(ExtractorThread(ExtractPhoneNumber(),data,lock))
    threads.append(ExtractorThread(ExtractWebsite(),data,lock))
    threads.append(ExtractorThread(ExtractInfo(),data,lock))
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()
    return (data['features'],data['errors'])