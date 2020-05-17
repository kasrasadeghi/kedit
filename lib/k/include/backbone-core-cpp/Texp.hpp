#pragma once

#include "Print.hpp"

#include <initializer_list>
#include <string>
#include <vector>
#include <algorithm>

struct Texp {
  std::vector<Texp> _children {};
  std::string value = "";

  using Children = decltype(Texp::_children);

  Texp() : Texp("", {}) {}
  Texp(const std::string& value) : Texp(value, {}) {}
  Texp(const std::string& value, const std::initializer_list<Texp>& children)
    : value(value), _children(children) {}

  void push(Texp t)        { _children.push_back(t); }
  size_t size() const      { return _children.size(); }

  const Texp& must_find(std::string_view view) const
    {
      auto result = find(view);
      if (result != end()) return *result;

      printerrln("could not find " + std::string(view) + " in :" + tabs());
      exit(1);
    }

  Children::const_iterator find(std::string_view view) const
    { return std::find_if(begin(), end(), [&view](Texp t) -> bool { return t.value == view; }); }

  // Representation  ========================================================
  std::string tabs(int indent = 0) const
    {
      std::string acc;
      for (int i = 0; i < indent; ++i)
        acc += "  ";

      acc += value + "\n";
      for (auto& c : _children) {
        acc += c.tabs(indent + 1);
      }
      return acc;
    }

  std::string paren() const
    {
      std::string acc;
      if (_children.size() == 0)
        acc += value;
      else
        {
          acc +=  "(" + value + " ";
          for (auto iter = _children.begin(); iter < _children.end(); ++iter)
            {
              acc += iter->paren();
              if (iter != _children.end() - 1)
                acc += " ";
            }
          acc += ")";
        }
      return acc;
    }

  // Access ================================================================
  Texp& operator[](int i)                 { return _children[i]; }
  const Texp& operator[](int i) const     { return _children[i]; }

  Children::iterator        begin()       { return _children.begin(); }
  Children::iterator        end()         { return _children.end(); }
  Children::const_iterator  begin() const { return _children.begin(); }
  Children::const_iterator  end() const   { return _children.end(); }

  Children::reference       back()        { return _children.back(); }
  Children::const_reference back() const  { return _children.back(); }
};

inline std::ostream& operator<<(std::ostream& out, Texp texp)
  { return out << texp.paren(); }
