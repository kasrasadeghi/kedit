#include "Editor.hpp"

void Editor::openBrowser(void)
  {
    if (menuToMenuTransitionCheck("File Browser")) return;
    makeBrowser(*allocMenu());
  }

void Editor::makeBrowser(Menu& curr)
  {
    curr.name = "File Browser";
    Texp cwd = pwd();

    // TODO change the command for selecting a child path that is not a folder

    // browser menu layout
    // - working directory is the root, which is text
    // - children are buttons
    //   - folder children are "cd <folder name>"
    //   - file children can be opened with the editor

    // TODO "cd .."
    // - should select the child folder we just came from

    // TODO cd - to a folder we already have visited in this browser
    // - should select the child we had previously selected

    // TODO incremental/fuzzy search

    curr._layout = Texp("text", {cwd.value});
    curr._layout.push(Texp("button",
                           {
                             Texp("\"..\""),
                             Texp("on", {Texp("press"), {Texp("cd", {Texp("\"..\"")})}})
                           })
                      );

    for (auto& child : cwd)
      {
        if (child.value.ends_with("/\""))
          {
            // cmd = "(on (press (cd %child)))"_texp
            auto cmd = Texp("on", {Texp("press"), {Texp("cd", {child})}});
            curr._layout.push(Texp("button", {child, cmd}));
          }
        else
          {
            // cmd = "(on (press (open %child)))"_texp
            auto cmd = Texp("on", {Texp("press"), {Texp("open", {child})}});
            curr._layout.push(Texp("button", {child, cmd}));
          }
      }

    auto unquote = [](std::string s) -> std::string
                   { return s.substr(1, s.length() - 2); };

    Menu::FunctionTable function_table {
      {"cd",     [&](const Texp& cmd) -> void {
                   command_history.push_back("(cd " + cmd.paren() + ")");
                   std::string c = unquote(cmd.value);
                   int a = chdir(c.c_str());
                   println("'cd ", c.c_str(), "'  exit: ", a);
                   makeBrowser(curr);
                 }},
      {"system", [&](const Texp& cmd) -> void {
                   std::string c = unquote(cmd.value);
                   system(c.c_str());
                   makeBrowser(curr);
                 }},
      {"open",   [&](const Texp& cmd) -> void {
                   command_history.push_back("(open " + cmd.paren() + ")");
                   std::string c = unquote(cmd.value);
                   freeCurrentMenu();
                   loadFile(c);
                 }}
    };

    curr.setHandlers(function_table);
    curr.parseLayout(curr._layout);
  }

void Editor::openSwap(void)
  {
    if (menuToMenuTransitionCheck("Swap")) return;
    makeSwap(*allocMenu());
  }

void Editor::makeSwap(Menu& curr)
  {
    curr.name = "Swap";
    auto unquote = [](const std::string& s) -> std::string { return s.substr(1, s.length() - 2); };
    auto quote = [](const std::string& s) -> std::string {
                   std::string quoted = "\"" + s + "\"";
                   return quoted;
                 };

    curr._layout = Texp("text", {Texp(quote("Buffers"))});

    for (ssize_t page_i = _pages.size() - 1; page_i >= 0; -- page_i)
      {
        auto* page = _pages[page_i];
        if (page->_type == Type::MenuT)
          {
            // TODO don't swap to self
            // TODO swap to menu?
            // auto* menu = (Menu*)page;
            // auto menu_index_str = str(menu - _menus.data());
            // auto cmd = Texp("swap", {Texp("menu"), menu_index_str});
            // curr._layout.push(Texp("button", {"Menu " + menu_index_str, cmd}));

            // printerrln("UNSUPPORTED: switching to menu");
          }
        else if (page->_type == Type::FileBufferT)
          {
            // TODO file name might need to change if current directory is changed
            auto* filebuffer = (FileBuffer*)page;
            // (on (press (swap %page_i)))
            auto cmd = Texp("on", {Texp("press"), { Texp("swap", {str(page_i)}) }});

            std::string file_name = quote(filebuffer->file._name);
            curr._layout.push(Texp("button", {file_name, cmd}));
          }
        else
          {
            // printerrln("ERROR: Page type '", page->_type, "' found in page list.");
            // auto cmd = Texp("swap", {Texp("\"UNSUPPORTED\"")});
            // curr._layout.push(Texp("button", {cmd}));
          }
      }

    Menu::FunctionTable function_table {
      {"swap",   [&](const Texp& cmd) -> void {
                   command_history.push_back("(swap " + cmd.paren() + ")");

                   constexpr auto int_parse = [](const std::string& s) -> size_t {
                                                return std::stoull(s);
                                              };
                   auto* curr = currentMenu();
                   swapToPage(int_parse(cmd.value));
                   freeMenu(curr);
                 }}
    };

    curr.setHandlers(function_table);
    curr.parseLayout(curr._layout);
  }
