import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeroPage extends StatefulWidget {
  const HeroPage({super.key});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            final person = people[index];
            return ListTile(
              onTap: () => Get.to(() => DetailsPage(person: person)),
              leading: Hero(
                  tag: person.emoji,
                  child:
                      Text(person.emoji, style: const TextStyle(fontSize: 40))),
              title: Text(person.name),
              subtitle: Text('${person.age} years old'),
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          },
        ),
      ),
    );
  }
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;

  const Person({required this.name, required this.age, required this.emoji});
}

List<Person> people = [
  const Person(name: 'John', age: 20, emoji: '😀'),
  const Person(name: 'Jane', age: 21, emoji: '👧'),
  const Person(name: 'Jack', age: 22, emoji: '🧑‍✈️')
];

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
            flightShuttleBuilder: (flightContext, animation, flightDirection,
                fromHeroContext, toHeroContext) {
              switch (flightDirection) {
                case HeroFlightDirection.push:
                  return Material(
                      color: Colors.transparent,
                      child: ScaleTransition(
                          scale: animation.drive(Tween<double>(
                                  begin: 0.0, end: 1.0)
                              .chain(CurveTween(curve: Curves.fastOutSlowIn))),
                          child: toHeroContext.widget));
                case HeroFlightDirection.pop:
                  return Material(
                      color: Colors.transparent,
                      child: ScaleTransition(
                          scale: animation.drive(
                              Tween<double>(begin: 0.0, end: 1.0).chain(
                                  CurveTween(
                                      curve: Curves.fastLinearToSlowEaseIn))),
                          child: fromHeroContext.widget));
              }
            },
            tag: person.emoji,
            child: Text(
              person.emoji,
              style: const TextStyle(fontSize: 50),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                person.name,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                '${person.age} years old',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
