#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")

sources = []

if env["platform"] == "linux":
    env.Append(CXXFLAGS = ['-fpermissive'])


env.Append(CPPDEFINES={"FLOATING_POINT": None, "USE_SMALLFT": None}) # "EXPORT": None ?
sources += Glob("src/*.cpp")

if env["platform"] == "macos":
    library = env.SharedLibrary(
        "demo_rtc/bin/libonevoip.{}.{}.framework/libonevoip.{}.{}.{}{}".format(
            env["platform"], env["target"], env["platform"], env["target"], env["arch"], env["SHLIBSUFFIX"]
        ),
        source=sources,
    )
else:
    library = env.SharedLibrary(
        "addons/hellonix/libhellonix{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
