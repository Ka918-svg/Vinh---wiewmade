#include <windows.h>
#include <stdlib.h>
#include <time.h>

const int WIDTH = 900;
const int HEIGHT = 700;
const char* TEXT1 = "suốt ngày ad tiktok lite, Xem hoài";
const char* TEXT2 = "ngày nào cũng quảng cáo tiktok lite, mạng xã hội, app free, web có khó chịu";

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    static DWORD startTime = 0;

    switch (uMsg) {
    case WM_CREATE:
        srand((unsigned int)time(0));
        startTime = GetTickCount();
        SetTimer(hwnd, 1, 50, NULL); // 50ms refresh
        return 0;

    case WM_TIMER:
    {
        HDC hdc = GetDC(hwnd);

        // Chữ 1
        SetTextColor(hdc, RGB(rand() % 256, rand() % 256, rand() % 256));
        SetBkMode(hdc, TRANSPARENT);
        TextOut(hdc, rand() % (WIDTH - 250), rand() % (HEIGHT - 50), TEXT1, strlen(TEXT1));

        // Chữ 2
        SetTextColor(hdc, RGB(rand() % 256, rand() % 256, rand() % 256));
        TextOut(hdc, rand() % (WIDTH - 250), rand() % (HEIGHT - 50), TEXT2, strlen(TEXT2));

        // Line ngẫu nhiên
        for (int i = 0; i < 3; i++) {
            HPEN hPen = CreatePen(PS_SOLID, 2, RGB(rand() % 256, rand() % 256, rand() % 256));
            SelectObject(hdc, hPen);
            MoveToEx(hdc, rand() % WIDTH, rand() % HEIGHT, NULL);
            LineTo(hdc, rand() % WIDTH, rand() % HEIGHT);
            DeleteObject(hPen);
        }

        // Polygon ngẫu nhiên
        POINT pts[5];
        for (int i = 0; i < 5; i++) {
            pts[i].x = rand() % WIDTH;
            pts[i].y = rand() % HEIGHT;
        }
        HBRUSH hBrush = CreateSolidBrush(RGB(rand() % 256, rand() % 256, rand() % 256));
        SelectObject(hdc, hBrush);
        Polygon(hdc, pts, 5);
        DeleteObject(hBrush);

        // Rectangle bo góc
        RoundRect(hdc,
            rand() % WIDTH, rand() % HEIGHT,
            rand() % WIDTH, rand() % HEIGHT,
            30, 30);

        // Ellipse ngẫu nhiên
        Ellipse(hdc,
            rand() % WIDTH, rand() % HEIGHT,
            rand() % WIDTH, rand() % HEIGHT);

        ReleaseDC(hwnd, hdc);

        // Sau 50 giây thì dừng
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
    const char CLASS_NAME[] = "GDIPayload";

    WNDCLASS wc = {};
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = CLASS_NAME;

    RegisterClass(&wc);

    HWND hwnd = CreateWindowEx(
        0,
        CLASS_NAME,
        "TikTok Lite Ad Spam Demo",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, WIDTH, HEIGHT,
        NULL, NULL, hInstance, NULL
    );

    ShowWindow(hwnd, nCmdShow);

    MSG msg = {};
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return 0;
}
