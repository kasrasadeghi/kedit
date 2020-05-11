#include <string_view>
#include <vector>
#include <utility>

#include <GLFW/glfw3.h>

struct Event {
  Event(const char* n, double t): name(n), elapsed_time(t) {}
  const char* name = "";
  double elapsed_time = 0;
};

struct Frame {
  double start_time = 0;
  double end_time = 0; // end time of last event until endFrame() is called, then actual frame's end time
  std::vector<Event> _events;
  double elapsedTime() const { return end_time - start_time; }
};

struct Profiler {
  inline void startFrame()
    {
      _frames.emplace_back();
      _frames.back().start_time = glfwGetTime();
    };

  void event(const char* name)
    {
      auto& curr = _frames.back();
      auto event_start_time = curr._events.empty() ? curr.start_time : curr.end_time;
      curr.end_time = glfwGetTime();
      auto elapsed_time = curr.end_time - event_start_time;
      curr._events.emplace_back(name, elapsed_time);
    };

  void endFrame()
    { _frames.back().end_time = glfwGetTime(); }

  void removeLastFrame()
    { _frames.pop_back(); }

  std::vector<Frame> _frames;
};
