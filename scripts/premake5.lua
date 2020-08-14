BPT_DIR = (path.getabsolute("..") .. "/")
RUNTIME_DIR = (path.getabsolute("..") .. "/runtime/")

EXTERNAL_DIR = (BPT_DIR .. "external/include/")
EXTERNAL_SRC_DIR = (BPT_DIR .. "external/src/")

-- $(SolutionDir).build\$(Platform)\$(Configuration)\
local BUILD_DIR = path.join(BPT_DIR, ".build")

--
-- Solution
--
workspace "bpt"
  language "C++"
  configurations {"Debug", "Release"}
  platforms {"x64"}
  startproject "bpt"
  cppdialect "C++latest"
  premake.vstudio.toolset = "v142"
  location "../.build/"

  filter { "configurations:Debug" }
    symbols "On"
  filter { "configurations:Release" }
    optimize "On"
  -- Reset the filter for other settings
  filter { }

  targetdir ("../.build/bin/%{prj.name}/%{cfg.longname}")
	objdir ("../.build/obj/%{prj.name}/%{cfg.longname}")

  floatingpoint "fast"

  defines {
    "WIN32",
    "_WIN32",
    "_WIN64",
    "_SCL_SECURE=0",
    "_SECURE_SCL=0",
    "_SCL_SECURE_NO_WARNINGS",
    "_CRT_SECURE_NO_WARNINGS",
    "_CRT_SECURE_NO_DEPRECATE",
    "SOKOL_D3D11"
  }
  
  linkoptions {
    "/ignore:4221", -- LNK4221: This object file does not define any previously undefined public symbols, so it will not be used by any link operation that consumes this library
  }

  disablewarnings {
    "4267",
    "28612",
  }

---
--- Projects
---

project("imgui")
  uuid(os.uuid("imgui"))
  kind "StaticLib"

  files {
    path.join(EXTERNAL_SRC_DIR, "imgui/**.cpp"),
    path.join(EXTERNAL_DIR, "imgui/**.h"),
  }

  includedirs {
    path.join(EXTERNAL_DIR, 'imgui/'),
  }

  configuration {}

BPT_SRC_DIR = path.join(BPT_DIR, "src")

project("bpt")
  uuid(os.uuid("bpt_lib"))
  kind "WindowedApp"

  files {
    path.join(BPT_SRC_DIR, "**.cpp"),
    path.join(BPT_SRC_DIR, "**.h"),
  }

  includedirs {
    BPT_SRC_DIR,
    EXTERNAL_DIR,
  }

  links {
    "imgui"
  }

  configuration {}
