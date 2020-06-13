#pragma once
#include <iostream>

// c++17 fold expressions

template <class... Args>
void print(Args&&... args)
  { (std::cout << ... << args) << std::flush; }

template<class... Args>
void println(Args&&... args)
  { (std::cout << ... << args) << std::endl << std::flush; }

template<class... Args>
void printerr(Args&&... args)
  { (std::cerr << ... << args) << std::flush; }

template<class... Args>
void printerrln(Args&&... args)
  { (std::cerr << ... << args) << std::endl << std::flush; }
