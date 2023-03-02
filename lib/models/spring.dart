import 'package:animations/models/particles.dart';

class Spring {
  Particle a;
  Particle b;
  double k;
  double restLength;
  Spring(
    this.a,
    this.b,
    this.k,
    this.restLength,
  );

  void update() {
    var forceApplied = b.position - a.position;
    var x = forceApplied.length - restLength;
    forceApplied.normalize();
    forceApplied.scale(k * x);
    a.applyForce(forceApplied);
    forceApplied.scale(-1);
    b.applyForce(forceApplied);
  }
}
