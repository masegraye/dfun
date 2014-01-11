module play.core.texturemanager;

import derelict.sdl2.sdl;
import derelict.sdl2.image;


class TextureManager {
    private this() {};

    @property
    static TextureManager Instance() {
        if (s_instance is null) {
            s_instance = new TextureManager();
        }
        return s_instance;
    }

    bool load(string fileName, string id, const(SDL_Renderer)* pRenderer) {

        SDL_Surface* pTempSurface = IMG_Load("./public/assets/claudius.png");

        SDL_Texture* pTexture = SDL_CreateTextureFromSurface(cast(SDL_Renderer*)pRenderer, pTempSurface);

        SDL_FreeSurface(pTempSurface);

        if (pTexture) {
            m_textureMap[id] = pTexture;
            return true;
        }

        return false;
    }

    void draw(string id,
        int x, int y,
        int width, int height,
        const(SDL_Renderer)* pRenderer,
        SDL_RendererFlip flip = SDL_FLIP_NONE) {

        SDL_Rect srcRect;
        SDL_Rect destRect;

        srcRect.x = srcRect.y = 0;
        srcRect.w = destRect.w = width;
        srcRect.h = destRect.h = height;
        destRect.x = x;
        destRect.y = y;

        SDL_RenderCopyEx(cast(SDL_Renderer*)pRenderer, m_textureMap[id],
            &srcRect, &destRect,
            0.0, cast(SDL_Point*)0,
            flip);
    }

    void drawFrame(string id,
        int x, int y,
        int width, int height,
        int currentRow, int currentFrame,
        const(SDL_Renderer)* pRenderer,
        SDL_RendererFlip flip = SDL_FLIP_NONE) {

        SDL_Rect srcRect;
        SDL_Rect destRect;

        srcRect.x = width * currentFrame;
        srcRect.y = height * (currentRow - 1);
        srcRect.w = destRect.w = width;
        srcRect.h = destRect.h = height;

        destRect.x = x;
        destRect.y = y;

        SDL_RenderCopyEx(cast(SDL_Renderer*)pRenderer, m_textureMap[id],
            &srcRect, &destRect,
            0.0, cast(SDL_Point*) 0,
            flip);

    }

private:
    static TextureManager s_instance;
    SDL_Texture*[string] m_textureMap;
}

