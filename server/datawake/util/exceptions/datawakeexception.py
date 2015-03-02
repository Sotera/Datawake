class DatawakeError(Exception):
    pass


class SessionError(DatawakeError):
    def __init__(self, method, value):
        self.value = value
        self.method = method

    def __str__(self):
        return repr(self.value) + " Calling method: " + str(self.method)