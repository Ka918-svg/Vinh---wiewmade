#include <windows.h>
#include <stdlib.h>
#include <time.h>

const int WIDTH = 800;
const int HEIGHT = 600;
const char* TEXT = "suốt ngày ad tiktok lite, Xem hoài";

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    static DWORD startTime = 0;

    switch(uMsg) {
        case WM_CREATE:
            srand((unsigned int)time(0));
            startTime = GetTickCount();
            SetTimer(hwnd, 1, 50, NULL); // Timer 50ms
            return 0;

        case WM_TIMER:
        {
            HDC hdc = GetDC(hwnd);

            // Clear background
            RECT rect;
            GetClientRect(hwnd, &rect);
            FillRect(hdc, &rect, (HBRUSH)(COLOR_WINDOW+1));

            // Vẽ chữ màu ngẫu nhiên
            COLORREF textColor = RGB(rand()%256, rand()%256, rand()%256);
            SetTextColor(hdc, textColor);
            SetBkMode(hdc, TRANSPARENT);
            TextOut(hdc, rand() % (WIDTH - 200), rand() % (HEIGHT - 50), TEXT, strlen(TEXT));

            // Vẽ line ngẫu nhiên
            for (int i = 0; i < 5; i++) {
                HPEN hPen = CreatePen(PS_SOLID, 1, RGB(rand()%256, rand()%256, rand()%256));
                SelectObject(hdc, hPen);
                MoveToEx(hdc, rand()%WIDTH, rand()%HEIGHT, NULL);
                LineTo(hdc, rand()%WIDTH, rand()%HEIGHT);
                DeleteObject(hPen);
            }

            // Vẽ polygon ngẫu nhiên
            POINT pts[3];
            for (int i = 0; i < 3; i++) {
                pts[i].x = rand() % WIDTH;
                pts[i].y = rand() % HEIGHT;
            }
            HBRUSH hBrush = CreateSolidBrush(RGB(rand()%256, rand()%256, rand()%256));
            SelectObject(hdc, hBrush);
            Polygon(hdc, pts, 3);
            DeleteObject(hBrush);

            ReleaseDC(hwnd, hdc);

            // Dừng sau 50 giây
            if (GetTickCount() - startTime >= 50000) {
                KillTimer(hwnd, 1);
                PostQuitMessage(0);
            }
            return 0;
        }

        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;

        default:
            return DefWindowProc(hwnd, uMsg, wParam, lParam);
    }
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nCmdShow) {
    const char CLASS_NAME[] = "RandomGDI";

    WNDCLASS wc = {};
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = CLASS_NAME;

    RegisterClass(&wc);

    HWND hwnd = CreateWindowEx(
        0,
        CLASS_NAME,
        "GDI TikTok Lite Spam",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, WIDTH, HEIGHT,
        NULL, NULL, hInstance, NULL
    );

    ShowWindow(hwnd, nCmdShow);

    MSG msg = {};
    while(GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return 0;
}
