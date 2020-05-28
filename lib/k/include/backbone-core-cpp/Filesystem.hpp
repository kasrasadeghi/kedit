#pragma once

#include <backbone-core-cpp/Texp.hpp>
#include <backbone-core-cpp/Print.hpp>

#include <filesystem>

inline Texp pwd()
  {
    using namespace std::filesystem;

    // TODO only quote if whitespace appears in path names

    std::string working_dir_path = absolute(path(".")).lexically_normal();
    auto workdir = Texp("\"" + working_dir_path + "\"");
    for (directory_entry result : directory_iterator("."))
      {
        auto child_value = result.path().lexically_normal().string();
        child_value += (result.is_directory() ? "/" : "");
        workdir.push(Texp("\"" + child_value + "\""));
      }
    return workdir;
  }
