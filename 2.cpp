#include <windows.h>
LRESULT CALLBACK WndProc(HWND hWnd, UINT nMsg, WPARAM wParam,LPARAM lParam);
int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPreInst, LPSTR lpszCmdLine, int nCmdShow)
{
	HWND hWnd;
	MSG msg;
	WNDCLASSEX wc;
	//fill the WNDCLASSEX object with the  appropriate values
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.lpfnWndProc = WndProc;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hInstance = hInst;
	wc.hIcon = LoadIcon(NULL,  IDI_EXCLAMATION);
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground =  (HBRUSH)GetStockObject(WHITE_BRUSH);
	wc.lpszMenuName = NULL;
	wc.lpszClassName =  L"BouncingBall";
	wc.hIconSm = LoadIcon(NULL,  IDI_EXCLAMATION);
	//register the new class
	RegisterClassEx(&wc);
	//create a window
	hWnd = CreateWindowEx(
	NULL,
	L"BouncingBall",
	L"The Bouncing Ball Program",
	WS_OVERLAPPEDWINDOW | WS_VISIBLE,
	CW_USEDEFAULT,
	CW_USEDEFAULT,
	CW_USEDEFAULT,
	CW_USEDEFAULT,
	NULL, 
	NULL,
	hInst,
	NULL
	);
	//event loop - handle all messages
	while(GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	//standard return value
	return (msg.wParam);
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT nMsg, WPARAM wParam,LPARAM lParam)
{
	//static variables used to keep track of 
	//the ball’s position
	static int dX = 5, dY = 5; //stores direction
	//stores position
	static int x = 0, y = 0, oldX = 0, oldY = 0;
	//device context and brush used for drawing
	HDC hDC;
	HBRUSH brush;
	//find out which message is being sent
	switch(nMsg)
	{
		case WM_CREATE:
		//create the timer (0.02 seconds)
		SetTimer(hWnd, 1, 20, NULL);		// SetTimer(handle, event ID, time in mili second)
		break;
		case WM_TIMER: //when the timer goes off (only one)
		//get the dc for drawing
		hDC = GetDC(hWnd);
		//use pure white
		brush = (HBRUSH)SelectObject(hDC, 
		GetStockObject(WHITE_BRUSH));
		//fill a RECT object with the 
		//appropriate values
		RECT temp;
		temp.left = oldX;
		temp.top = oldY;
		temp.right = oldX + 30;
		temp.bottom = oldY + 30;
		//cover the old ellipse
		FillRect(hDC, &temp, brush);
		//get ready to draw the new ellipse
		brush = (HBRUSH)SelectObject(hDC, 
		GetStockObject(GRAY_BRUSH));
		//draw it
		Ellipse(hDC, x, y, 30 + x, 30 +  y);	// left, top, right, bottom 
		/*The Ellipse function draws an ellipse. The center of the ellipse is the center 
		of the specified bounding rectangle. The ellipse is outlined by using 
		the current pen and is filled by using the current brush.

		*/
		//update the values
		oldX = x;
		oldY = y;
		//prep the new coordinates for next time
		x += dX;
		y += dY;
		//get the window size and store it in rect
		RECT rect;
		GetClientRect(hWnd, &rect);
		//if the circle is going off the edge then
		//reverse its direction
		if(x + 30 > rect.right || x  < 0)
		{
			dX = -dX;
		}
		if(y + 30 > rect.bottom || y  < 0)
		{
			dY = -dY;
		}
		//put the old brush back
		SelectObject(hDC, brush); // selects an object into the specified device context 
		//release the dc
		ReleaseDC(hWnd, hDC); //freeing device context for use by other applications
		break;
		case WM_DESTROY:
		//destroy the timer
		KillTimer(hWnd, 1); // kill timer of event 1
		//end the program
		PostQuitMessage(0);
		break;
		default:
		//let Windows handle every other message
		return(DefWindowProc(hWnd, nMsg, wParam, lParam));
	}
	return 0;
}



