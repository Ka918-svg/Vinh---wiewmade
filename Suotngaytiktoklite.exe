#include <windows.h>
#include <cstdlib>
#include <ctime>

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    switch (uMsg)
    {
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

COLORREF RandomColor()
{
    return RGB(rand() % 256, rand() % 256, rand() % 256);
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nCmdShow)
{
    srand((unsigned int)time(0));

    const char CLASS_NAME[] = "GDI_Spam_Window";

    WNDCLASS wc = {};
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = CLASS_NAME;

    RegisterClass(&wc);

    HWND hwnd = CreateWindowEx(
        0,
        CLASS_NAME,
        "Spam GDI TikTok",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, 800, 600,
        NULL,
        NULL,
        hInstance,
        NULL
    );

    ShowWindow(hwnd, nCmdShow);

    HDC hdc = GetDC(hwnd);
    RECT rect;
    GetClientRect(hwnd, &rect);

    while (true)
    {
        // Clear screen
        FillRect(hdc, &rect, (HBRUSH)(COLOR_WINDOW+1));

        // Draw random lines
        for (int i = 0; i < 10; i++)
        {
            HPEN pen = CreatePen(PS_SOLID, 2, RandomColor());
            SelectObject(hdc, pen);
            MoveToEx(hdc, rand() % rect.right, rand() % rect.bottom, NULL);
            LineTo(hdc, rand() % rect.right, rand() % rect.bottom);
            DeleteObject(pen);
        }

        // Draw random polygon
        POINT pts[5];
        for (int i = 0; i < 5; i++)
        {
            pts[i].x = rand() % rect.right;
            pts[i].y = rand() % rect.bottom;
        }
        HBRUSH brush = CreateSolidBrush(RandomColor());
        HPEN penPoly = CreatePen(PS_SOLID, 2, RandomColor());
        SelectObject(hdc, brush);
        SelectObject(hdc, penPoly);
        Polygon(hdc, pts, 5);
        DeleteObject(brush);
        DeleteObject(penPoly);

        // Draw the text
        SetTextColor(hdc, RandomColor());
        SetBkMode(hdc, TRANSPARENT);
        DrawTextA(hdc, "suốt ngày ad tiktok lite, Xem hoài", -1, &rect, DT_SINGLELINE | DT_CENTER | DT_VCENTER);

        Sleep(50);
        MSG msg;
        while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
        {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
    }

    ReleaseDC(hwnd, hdc);
    return 0;
}
