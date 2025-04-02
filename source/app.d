import sdl3;

pragma(lib, "SDL3");

struct App
{
	SDL_Window* window = null;
	SDL_Renderer* renderer = null;
	int screenWidth = 1280;
	int screenHeight = 720;
	int xPosition = 0;
	ulong lastTickMs = 0;
}

__gshared App app;

extern(C) SDL_AppResult SDL_AppInit(void** appstate, int argc, char** argv)
{
	*appstate = &app;
	int i;
	SDL_SetAppMetadata("BasicShapes", "1.0", "www.watbenjedan.tk");

	app.lastTickMs = SDL_GetTicks();

	if (!SDL_Init(SDL_INIT_VIDEO))
	{
		SDL_Log("Couldn't initialize SDL: %s", SDL_GetError());
		return SDL_APP_FAILURE;
	}

	if (!SDL_CreateWindowAndRenderer("BasicShapes", app.screenWidth, app.screenHeight, 0, &app.window, &app.renderer))
	{
		SDL_Log("Couldn't create window/renderer: %s", SDL_GetError());
		return SDL_APP_FAILURE;
	}

	return SDL_APP_CONTINUE;
}

extern(C) SDL_AppResult SDL_AppEvent(void* appstate, SDL_Event* event)
{
	if (event.type == SDL_EVENT_QUIT)
		return SDL_APP_SUCCESS;

	return SDL_APP_CONTINUE;
}

// Framer per second
enum fps = 60;
enum tickMs = 1000 / fps;

extern(C) SDL_AppResult SDL_AppIterate(void* appstate)
{
	auto app = cast(App*) appstate;

	const nowMs = SDL_GetTicks();
	while ((nowMs - app.lastTickMs) >= tickMs)
	{
		app.xPosition += 2;
		if (app.xPosition > 1280)
			app.xPosition = 0;

		app.lastTickMs += tickMs;
	}

	SDL_SetRenderDrawColor(app.renderer, 255, 156, 0, SDL_ALPHA_OPAQUE);
	SDL_RenderClear(app.renderer);

	SDL_SetRenderDrawColor(app.renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
	SDL_FRect rect = SDL_FRect(app.xPosition, 100.0, 120.0, 60.0);
	SDL_RenderFillRect(app.renderer, &rect);

	SDL_RenderPresent(app.renderer);
	return SDL_APP_CONTINUE;
}

extern(C) void SDL_AppQuit(void* appstate, SDL_AppResult result)
{
	//
}
