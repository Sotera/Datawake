class Entity(object):
    def __init__(self, d):
        self.item = d

    def __eq__(self, other):
        return self.item.get("name") == other.item.get("name") and other.item.get("type") == self.item.get("type")

    def __hash__(self):
        return hash(self.item.get("name"))

    def __dict__(self):
        return self.item
