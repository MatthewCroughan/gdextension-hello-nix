#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")

sources = []

if env["platform"] == "linux":
    env.Append(CXXFLAGS = ['-fpermissive'])


env.Append(CPPDEFINES={"FLOATING_POINT": None, "USE_SMALLFT": None}) # "EXPORT": None ?
sources += Glob("src/*.cpp")

library = env.SharedLibrary(
    "addons/hellonix/libhellonix{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
    source=sources,
)

Default(library)
