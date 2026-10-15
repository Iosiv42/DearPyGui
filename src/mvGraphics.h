#pragma once

#include "mvCore.h"
#include "mvTextures.h"

// forward declarations
struct mvGraphics;
struct mvViewport;

mvGraphics setup_graphics(mvViewport& viewport);
void       resize_swapchain(mvGraphics& graphics, int width, int height);
void       cleanup_graphics(mvGraphics& graphics);
void       present(mvGraphics& graphics, mvColor& clearColor, bool vsync);

struct mvGraphics
{
    bool           ok = false;
    void* backendSpecifics = nullptr;
};

//-----------------------------------------------------------------------------
// The Dear ImGui backends keep their state in the current ImGui context and
// their *_Shutdown() entry points assert (and then dereference null) if they
// are called twice, or before the matching *_Init() ever ran.  Teardown has to
// tolerate both cases: a viewport can be created without ever being shown, and
// destroy_context() may be reached after a partially failed startup.
//
// These helpers make the shutdown paths below idempotent so that ordering
// mistakes turn into no-ops instead of crashes.
//-----------------------------------------------------------------------------

inline bool mvPlatformBackendInitialized()
{
    return ImGui::GetCurrentContext() != nullptr
        && ImGui::GetIO().BackendPlatformUserData != nullptr;
}

inline bool mvRendererBackendInitialized()
{
    return ImGui::GetCurrentContext() != nullptr
        && ImGui::GetIO().BackendRendererUserData != nullptr;
}
