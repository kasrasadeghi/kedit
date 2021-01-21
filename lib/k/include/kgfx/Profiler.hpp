#include <string_view>
#include <vector>
#include <utility>

#include <GLFW/glfw3.h>

struct Event {
  inline Event(const char* n, double t): name(n), elapsed_time(t) {}
  const char* name = "";
  double elapsed_time = 0;
};

struct Frame {
  double start_time = 0;
  double end_time = 0; // end time of last event until endFrame() is called, then actual frame's end time
  std::vector<Event> _events;
  inline double elapsedTime() const { return end_time - start_time; }
};

struct FrameCounter {
  std::vector<Frame> _frames;

  inline void startFrame()
    {
      _frames.emplace_back();
      _frames.back().start_time = glfwGetTime();
    };

  inline void event(const char* name)
    {
      auto& curr = _frames.back();
      auto event_start_time = curr._events.empty() ? curr.start_time : curr.end_time;
      curr.end_time = glfwGetTime();
      auto elapsed_time = curr.end_time - event_start_time;
      curr._events.emplace_back(name, elapsed_time);
    };

  inline void endFrame()
    { _frames.back().end_time = glfwGetTime(); }

  inline void removeLastFrame()
    { _frames.pop_back(); }
};

struct Profiler {
  FrameCounter fc;

  // options
  // ignore any frames that are "good enough"
  struct {
    bool ignore_good_frames = true;
    double good_frame_threshold = 2.f; // a frame is good if it's less than twice as long as we would expect
  } options;

  // frame-rate bookkeeping
  size_t framecounter = 0;
  double fps_counter_time = glfwGetTime();
  double delta_time = 0.f;
  double expected_framerate;
  double framerate;
  double moving_avg_framerate;
  inline Profiler(double expected_framerate) :
    expected_framerate(expected_framerate),
    framerate(expected_framerate),
    moving_avg_framerate(framerate) {}

  inline void event(const char* name)
    { fc.event(name); }

  inline void startFrame()
    {
      fc.startFrame();

      framecounter ++;

      constexpr int geometric_falloff_rate = 16; // try for power of 2
      delta_time = (glfwGetTime() - fps_counter_time);
      fps_counter_time = glfwGetTime();
      framerate = 1 / delta_time;
      moving_avg_framerate = ((moving_avg_framerate * (geometric_falloff_rate - 1)) + framerate) / geometric_falloff_rate;

      // the moving geometric rate is, at point i+1,
      //   one part the current rate and
      //   n-1 parts the previous moving geometric rate
      //
      //                (FR_i * (falloff - 1)) + fr_i
      //    FR_{i+1} = -------------------------------
      //                          falloff
    }

  inline void endFrame()
    {
      fc.endFrame();

      if (options.ignore_good_frames)
        {
          double good_frame_length = options.good_frame_threshold / expected_framerate;
          double current_frame_length = fc._frames.back().elapsedTime();
          bool good_frame = current_frame_length < good_frame_length;
          if (good_frame)
            {
              fc.removeLastFrame();
            }
        }
    }
};
