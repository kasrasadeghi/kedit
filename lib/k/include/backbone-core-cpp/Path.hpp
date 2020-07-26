#pragma once

#include <filesystem>

/// like man 3 dirname
std::string parent_dir(const std::string& filepath)
  { using namespace std::filesystem; return path(filepath).parent_path().string(); }

std::string pathcat(const std::string& path_A, const std::string& path_B)
  { using namespace std::filesystem; return (path(path_A) / path(path_B)).string(); }

std::string abs_path(const std::string& filepath)
  { using namespace std::filesystem; return absolute(path(filepath)).string(); }
