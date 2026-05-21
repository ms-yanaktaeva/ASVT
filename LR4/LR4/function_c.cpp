#include <cmath>

// Функция для вычисления |ctg(x) + sin(x)|
extern "C" double CalcFunction(double x)
{
    double ctg_x;
    double result;

    // Обработка особых точек (x = 0, π, 2π...)
    // При x=0 ctg(x) стремится к бесконечности
    if (fabs(x) < 1e-10)
    {
        result = 1e10; // Большое число для интеграла
    }
    else
    {
        // Вычисление котангенса: ctg(x) = cos(x)/sin(x)
        ctg_x = cos(x) / sin(x);
        result = fabs(ctg_x + sin(x));
    }

    return result;
}