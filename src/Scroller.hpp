#pragma once

// smooth scrolling logic
// TODO slow scrolling
// TODO fast scrolling
// TODO handle laptop scrolling much better
struct Scroller {

  double target = 0;
  double velocity = 0;
  double position = 0;

  inline void reset()
    {
      target = 0;
      velocity = 0;
      position = 0;
    }

  inline void tick(double delta_time)
    {
      auto gone_past = [&](){
        // we've gone past if velocity direction is the opposite way we should go
        return 0 > (velocity * (target - position));
      };

      velocity = (target - position) * 20;
      if (gone_past())
        {
          position = target;
          return;
        }

      // if we're lagging, don't worry about smooth scrolling
      if (delta_time > 0.05 || delta_time < 0.001)
        {
          position = target;
          return;
        }

      position += velocity * delta_time;
    }
};
