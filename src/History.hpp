#pragma once

#include <backbone-core-cpp/Texp.hpp>
#include <kgfx/Str.hpp>

#include <string>
#include <string_view>
#include <vector>

struct History {
  std::vector<Texp> commands;

  inline void push(std::string S)
    { commands.push_back(Texp(S)); }

  inline Texp pop(void)
    {
      auto copy = commands.back();
      commands.pop_back();
      return copy;
    }

  inline void addCursor(const Cursor& cursor, std::string_view name)
    {
      if (commands.empty())
        {
          printerrln("ERROR: no command to add cursor to");
          return;
        }

      Texp cursor_texp {str(name)};
      cursor_texp.push(str(cursor.line));
      cursor_texp.push(str(cursor.column));

      commands.back().push(cursor_texp);
    }

  inline Cursor parseCursor(const Texp& texp)
    {
      constexpr auto int_parse = [](const std::string& s) -> size_t {
                                   return std::stoull(s);
                                 };
      return Cursor{int_parse(texp[0].value), int_parse(texp[1].value)};
    }

  inline void add(std::string S)
    {
      if (commands.empty())
        {
          printerrln("ERROR: no command to add '" + S + "' to");
          return;
        }

      commands.back().push(Texp(S));
    }
};
