#include "mvGraphics.h"

#include "mvAppleSpecifics.h"

#include "mvViewport.h"

#include "imgui_impl_glfw.h"
#include "imgui_impl_metal.h"

mvGraphics
setup_graphics(mvViewport &viewport)
{
    mvGraphics graphics{};
    graphics.backendSpecifics = new mvGraphics_Metal();

    auto viewportData = (mvViewportData*)viewport.platformSpecifics;
    auto graphicsData = (mvGraphics_Metal*)graphics.backendSpecifics;

    graphicsData->device = MTLCreateSystemDefaultDevice();
    graphicsData->commandQueue = [graphicsData->device  newCommandQueue];

    ImGui_ImplMetal_Init(graphicsData->device);

    NSWindow *nswin = glfwGetCocoaWindow(viewportData->handle);
    viewportData->layer = [CAMetalLayer layer];
    viewportData->layer.device = graphicsData->device;
    viewportData->layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    nswin.contentView.layer = viewportData->layer;
    nswin.contentView.wantsLayer = YES;

    graphicsData->renderPassDescriptor = [MTLRenderPassDescriptor new];

    return graphics;
}

void
resize_swapchain(mvGraphics &graphics, int width, int height)
{

}

void
cleanup_graphics(mvGraphics &graphics)
{
    auto graphicsData = (mvGraphics_Metal*)graphics.backendSpecifics;

    // Nothing was ever set up - the viewport was created but never shown.
    if (graphicsData == nullptr)
        return;

    graphics.backendSpecifics = nullptr;

    // The Metal renderer backend is initialized in setup_graphics() above, so it
    // is released here.  It has to run while the CAMetalLayer that belongs to the
    // GLFW window is still around, i.e. before mvCleanupViewport().
    if (mvRendererBackendInitialized())
        ImGui_ImplMetal_Shutdown();

    graphicsData->renderPassDescriptor = nil;
    graphicsData->commandQueue = nil;
    graphicsData->device = nil;

    delete graphicsData;
}

void
present(mvGraphics &graphics, mvColor &clearColor, bool vsync)
{

}