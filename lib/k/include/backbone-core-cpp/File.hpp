#pragma once

#include <backbone-core-cpp/Print.hpp>
#include <backbone-core-cpp/StrView.hpp>

#include <string>

#include <stdint.h>    // uint32_t, int32_t, similar
#include <fcntl.h>     // open
#include <sys/types.h> // time_t
#include <sys/mman.h>  // mmap, munmap
#include <unistd.h>    // lseek, close, write, ftruncate
#include <stdlib.h>    // realpath
#include <sys/stat.h>  // fstat

struct File {
  std::string _name = "";
  int32_t _file_descriptor = -1;

  inline static File _open(StringView filename, int32_t flags)
    {
      File result;
      result._name = filename.stringCopy();
      char* abs_path = ::realpath(result._name.c_str(), nullptr);
      result._name = std::string(abs_path);
      free(abs_path); // realpath calls malloc
      result._file_descriptor = ::open(filename.data(), flags);

      if (-1 == result._file_descriptor)
        {
          printerrln("error opening file at ", filename);
        }

      return result;
    }

  // TODO open should not create

  inline static File open(StringView filename)
    { return _open(filename, O_RDONLY); }

  inline static File openrw(StringView filename)
    { return _open(filename, O_RDWR); }

  inline int64_t size()
    { return _lseek(0, SEEK_END); }

  inline time_t access_time()
    {
      struct stat buf;
      _stat(&buf);
      return buf.st_atime;
    }

  inline time_t modify_time()
    {
      struct stat buf;
      _stat(&buf);
      return buf.st_mtime;
    }

  inline time_t status_change_time()
    {
      struct stat buf;
      _stat(&buf);
      return buf.st_ctime;
    }

  inline int _stat(struct stat* buf)
    { return ::fstat(_file_descriptor, buf); }

  inline char* _mmap(char* addr, int64_t file_length, int32_t prot, int32_t flags, int32_t offset)
    {
      char* result = (char*)::mmap(addr, file_length, prot, flags, _file_descriptor, offset);
      if (-1 == (int64_t)(result)) {
        printerrln("file descriptor: ", _file_descriptor);
        perror("backbone-core-cpp: mmap");
      }
      return result;
    }

  inline StringView read()
    {
      auto file_length = size();
      return {(char*)(_mmap(nullptr, file_length, PROT_READ, MAP_PRIVATE, 0)), (uint64_t)(file_length) };
    }

  inline StringView readwrite()
    {
      auto file_length = size();
      return {(char*)(_mmap(nullptr, file_length, PROT_READ | PROT_WRITE , MAP_PRIVATE, 0)), (uint64_t)(file_length) };
    }

  inline ssize_t overwrite(StringView S)
    {
      _lseek(0, SEEK_SET); // seek to beginning of file
      if (int result = ftruncate(_file_descriptor, S.length()); result)
        {
          auto status = fcntl(_file_descriptor, F_GETFL);
          println("readonly? ", (status & O_ACCMODE) == O_RDONLY);
          perror("ftruncate");
        }
      return ::write(_file_descriptor, S.data(), S.length());
    }

  inline off_t _lseek(off_t offset, int whence)
    { return ::lseek(_file_descriptor, offset, whence); }

  // requires std::move
  inline static void unread(StringView&& view)
    { ::munmap(view._data, view._length); }

  /// requires std::move
  inline static void close(File&& file)
    {
      ::close(file._file_descriptor);
      file._name = "";
      file._file_descriptor = -1;
    }
};
