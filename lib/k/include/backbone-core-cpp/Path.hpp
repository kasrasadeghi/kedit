#pragma once

#include <filesystem>

/// like man 3 dirname
std::string parent_dir(const std::string& filepath)
  { using namespace std::filesystem; return path(filepath).parent_path().string(); }

std::string pathcat(const std::string& path_A, const std::string& path_B)
  { using namespace std::filesystem; return (path(path_A) / path(path_B)).string(); }

std::string abs_path(const std::string& filepath)
  { using namespace std::filesystem; return absolute(path(filepath)).string(); }

inline bool is_file(std::string_view s)
  { return std::filesystem::is_regular_file(s); }

inline bool is_directory(std::string_view s)
  { return std::filesystem::is_directory(s); }
