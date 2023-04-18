import 'package:findmyfun/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Create Event, Preference and Message', () {
    String idTest = "eventtest";
    String addressTest = "Address Test";
    String cityTest = "City Test";
    String countryTest = "Country Test";
    String descriptionTest = "This event is only for testing purposes";
    String imageTest =
        "https://www.freecodecamp.org/espanol/news/content/images/2022/02/5f9c9a4c740569d1a4ca24c2.jpg";
    String nameTest = "Event for testing purposes";
    double latitudeTest = 0;
    double longitudeTest = 0;
    DateTime startDateTest = DateTime.now();
    DateTime visibleFromTest = DateTime.now();
    List<Preferences> tagsTest = [];
    Preferences preferenceTest =
        Preferences(id: "000111000111000111", name: "test");
    tagsTest.add(preferenceTest);
    List<String> usersTest = [];
    usersTest.add("idtest");
    int maxUsersTest = 8;
    List<Messages> messagesTest = [];
    Messages messageTest = Messages(
        date: DateTime.now(),
        userId: "idtest",
        text: "This message is only for testing purposes");
    messagesTest.add(messageTest);
    Event event = Event(
        address: addressTest,
        city: cityTest,
        country: countryTest,
        description: descriptionTest,
        image: imageTest,
        name: nameTest,
        latitude: latitudeTest,
        longitude: longitudeTest,
        startDate: startDateTest,
        tags: tagsTest,
        users: usersTest,
        maxUsers: maxUsersTest,
        messages: messagesTest,
        visibleFrom: visibleFromTest,
        id: idTest);
    assert(event.address == addressTest);
    assert(event.city == cityTest);
    assert(event.country == countryTest);
    assert(event.description == descriptionTest);
    assert(event.image == imageTest);
    assert(event.name == nameTest);
    assert(event.latitude == latitudeTest);
    assert(event.longitude == longitudeTest);
    assert(event.startDate == startDateTest);
    assert(event.tags == tagsTest);
    assert(event.users == usersTest);
    assert(event.maxUsers == maxUsersTest);
    assert(event.id == idTest);
  });
  test('Create User with free suscription', () {
    String idTest = "usertest";
    String nameTest = "Name Test";
    String surnameTest = "Surname Test";
    String cityTest = "City Test";
    String usernameTest = "Username Test";
    String emailTest = "test@test.com";
    String imageTest =
        "https://www.freecodecamp.org/espanol/news/content/images/2022/02/5f9c9a4c740569d1a4ca24c2.jpg";
    List<Preferences> preferencesTest = [];
    Preferences preferenceTest =
        Preferences(id: "000111000111000111", name: "test");
    preferencesTest.add(preferenceTest);
    List<String> usersTest = [];
    usersTest.add("idtest");
    Subscription subscriptionTest =
        Subscription(numEventsCreatedThisMonth: 0, type: SubscriptionType.free);
    User user = User(
        name: nameTest,
        surname: surnameTest,
        city: cityTest,
        username: usernameTest,
        email: emailTest,
        image: imageTest,
        preferences: preferencesTest,
        subscription: subscriptionTest,
        id: idTest);
    assert(user.name == nameTest);
    assert(user.surname == surnameTest);
    assert(user.city == cityTest);
    assert(user.username == usernameTest);
    assert(user.email == emailTest);
    assert(user.image == imageTest);
    assert(user.preferences == preferencesTest);
    assert(user.subscription == subscriptionTest);
    assert(user.id == idTest);
    assert(user.isAdmin == false);
    assert(user.isCompany == false);
    assert(user.isPremium == false);
  });
  test('Create User with company suscription', () {
    String idTest = "u";
    String nameTest = "Name Test";
    String surnameTest = "Surname Test";
    String cityTest = "City Test";
    String usernameTest = "Username Test";
    String emailTest = "test@test.com";
    String imageTest =
        "https://www.freecodecamp.org/espanol/news/content/images/2022/02/5f9c9a4c740569d1a4ca24c2.jpg";
    List<Preferences> preferencesTest = [];
    Preferences preferenceTest =
        Preferences(id: "000111000111000111", name: "test");
    preferencesTest.add(preferenceTest);
    List<String> usersTest = [];
    usersTest.add("idtest");
    Subscription subscriptionTest = Subscription(
        numEventsCreatedThisMonth: 0, type: SubscriptionType.company);
    User user = User(
        name: nameTest,
        surname: surnameTest,
        city: cityTest,
        username: usernameTest,
        email: emailTest,
        image: imageTest,
        preferences: preferencesTest,
        subscription: subscriptionTest,
        id: idTest);
    user.isCompany = (user.subscription.type == SubscriptionType.company);
    assert(user.name == nameTest);
    assert(user.surname == surnameTest);
    assert(user.city == cityTest);
    assert(user.username == usernameTest);
    assert(user.email == emailTest);
    assert(user.image == imageTest);
    assert(user.preferences == preferencesTest);
    assert(user.subscription == subscriptionTest);
    assert(user.id == idTest);
    assert(user.isAdmin == false);
    assert(user.isCompany == true);
    assert(user.isPremium == false);
  });
  test('Create User with premium suscription', () {
    String idTest =
        "usertestttttttttttjwneuidfhweuihraosdhflkJASDDLJKNMASJOCKNOUIAEHDFLJKNASJLKFDHluhJHDOUEDFGUAHSLJKGHALIUSDHFJKHjkhjksdhflkjashdfgulhquiwehflmzxclkñmañslkjgouiahe";
    String nameTest = "Name Test";
    String surnameTest = "Surname Test";
    String cityTest = "City Test";
    String usernameTest = "Username Test";
    String emailTest = "test@test.com";
    String imageTest =
        "https://www.freecodecamp.org/espanol/news/content/images/2022/02/5f9c9a4c740569d1a4ca24c2.jpg";
    List<Preferences> preferencesTest = [];
    Preferences preferenceTest =
        Preferences(id: "000111000111000111", name: "test");
    preferencesTest.add(preferenceTest);
    List<String> usersTest = [];
    usersTest.add("idtest");
    Subscription subscriptionTest = Subscription(
        numEventsCreatedThisMonth: 0, type: SubscriptionType.premium);
    User user = User(
        name: nameTest,
        surname: surnameTest,
        city: cityTest,
        username: usernameTest,
        email: emailTest,
        image: imageTest,
        preferences: preferencesTest,
        subscription: subscriptionTest,
        id: idTest);
    user.isPremium = (user.subscription.type == SubscriptionType.premium);
    assert(user.name == nameTest);
    assert(user.surname == surnameTest);
    assert(user.city == cityTest);
    assert(user.username == usernameTest);
    assert(user.email == emailTest);
    assert(user.image == imageTest);
    assert(user.preferences == preferencesTest);
    assert(user.subscription == subscriptionTest);
    assert(user.id == idTest);
    assert(user.isAdmin == false);
    assert(user.isCompany == false);
    assert(user.isPremium == true);
  });
  test('Create User with free suscription and two notifications', () {
    String idTest = "usertestnotification";
    String nameTest = "Name Test";
    String surnameTest = "Surname Test";
    String cityTest = "City Test";
    String usernameTest = "Username Test";
    String emailTest = "test@test.com";
    String imageTest =
        "https://www.freecodecamp.org/espanol/news/content/images/2022/02/5f9c9a4c740569d1a4ca24c2.jpg";
    List<Preferences> preferencesTest = [];
    Preferences preferenceTest =
        Preferences(id: "000111000111000111", name: "test");
    preferencesTest.add(preferenceTest);
    List<String> usersTest = [];
    usersTest.add("idtest");
    Subscription subscriptionTest =
        Subscription(numEventsCreatedThisMonth: 0, type: SubscriptionType.free);
    List<ImportantNotification> notificationsTest = [];
    ImportantNotification firstNotification = ImportantNotification(
        userId: "usertestnotification",
        date: DateTime.now(),
        info:
            "This notification is only for test purposes and should be the first on the list");
    notificationsTest.add(firstNotification);
    ImportantNotification secondNotification = ImportantNotification(
        userId: "usertestnotification",
        date: DateTime.now(),
        info:
            "This notification is only for test purposes and should be the second on the list");
    notificationsTest.add(secondNotification);
    User user = User(
        name: nameTest,
        surname: surnameTest,
        city: cityTest,
        username: usernameTest,
        email: emailTest,
        image: imageTest,
        preferences: preferencesTest,
        subscription: subscriptionTest,
        notifications: notificationsTest,
        id: idTest);
    assert(user.name == nameTest);
    assert(user.surname == surnameTest);
    assert(user.city == cityTest);
    assert(user.username == usernameTest);
    assert(user.email == emailTest);
    assert(user.image == imageTest);
    assert(user.preferences == preferencesTest);
    assert(user.subscription == subscriptionTest);
    assert(user.notifications.first == firstNotification);
    assert(user.notifications == notificationsTest);
    assert(user.id == idTest);
    assert(user.isAdmin == false);
    assert(user.isCompany == false);
    assert(user.isPremium == false);
  });
  test('Create Event Point', () {
    String idTest = "eventpointtest";
    String addressTest = "Address Test";
    String cityTest = "City Test";
    String countryTest = "Country Test";
    String descriptionTest = "This event point is only for testing purposes";
    String nameTest = "Name Test";
    String imageTest =
        "https://www.freecodecamp.org/espanol/news/content/images/2022/02/5f9c9a4c740569d1a4ca24c2.jpg";
    double latitudeTest = 0;
    double longitudeTest = 0;
    EventPoint eventPoint = EventPoint(
        address: addressTest,
        city: cityTest,
        country: countryTest,
        description: descriptionTest,
        image: imageTest,
        name: nameTest,
        latitude: latitudeTest,
        longitude: longitudeTest,
        id: idTest);
    assert(eventPoint.address == addressTest);
    assert(eventPoint.city == cityTest);
    assert(eventPoint.country == countryTest);
    assert(eventPoint.description == descriptionTest);
    assert(eventPoint.image == imageTest);
    assert(eventPoint.name == nameTest);
    assert(eventPoint.latitude == latitudeTest);
    assert(eventPoint.longitude == longitudeTest);
    assert(eventPoint.id == idTest);
  });
}
