import registration_mod

# PersonStore is responsible for access to a persistent
# collection of Person records in the database.
class PersonStore():

    def __init__(self, db):
        self.db = db

    def deleteAll(self):
        """Remove all the records from the database."""
        # first remove all registrations that reference persons
        registration_mod.RegistrationStore(self.db).deleteAll()
        self.db.execute("DELETE FROM PERSON;", ())

    def getByName(self, name):
        result = self.db.fetchAll(
            "SELECT * FROM PERSON WHERE name=%s;", (name,))
        if len(result) == 1:
            row = result[0]
            person = Person(row[0], row[1], row[2])
            return person
        elif len(result) > 1:
            raise NameError("more than one person with name: '%s';" % name)
        else:
            return None

    def getById(self, id):
        result = self.db.fetchAll(
            "SELECT * FROM PERSON WHERE id=%s;", (id,))
        if len(result) == 1:
            row = result[0]
            person = Person(row[0], row[1], row[2])
            return person
        elif len(result) > 1:
            raise NameError("more than one person with name: '%s';" % name)
        else:
            return None

    def createPerson(self, name, born):
        """create registration for person with name in tournament"""
        self.db.execute(
            "INSERT INTO PERSON (name,born) VALUES(%s,%s);", (name, born,))

# Person is responsible for attributes of a player
# needed by this tournament application.
class Person():

    def __init__(self, id, name, born):
        self.id = id
        self.name = name
        self.born = born
