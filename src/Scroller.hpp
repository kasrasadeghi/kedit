#pragma once

// smooth scrolling logic
struct Scroller {

  double target = 0;
  double velocity = 0;
  double position = 0;
  double target_previous = 0;

  void tick(double delta_time)
    {
      // +1 if positive, -1 if negative, 0 otherwise
      constexpr auto signed_normalize = [](double x) { return x > 0 ? 1 : x < 0 ? -1 : 0; };
      constexpr auto normalize = [](double x) { return x == 0 ? 0 : x/x; };
      constexpr auto abs_distance = [](double x, double y) { return (x - y) > 0 ? x - y : y - x; };
      constexpr auto max = [](double x, double y) { return x > y ? x : y; };

      auto gone_past = [&](){
        // we've gone past if velocity direction is the opposite way we should go
        return 0 > (velocity * (target - position));
      };

      velocity = (target - position) * 20;
      if (gone_past())
        {
          position = target;
        }
      position += velocity * delta_time;
    }
};
