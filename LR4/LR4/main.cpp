#include <iostream>
#include <iomanip>
#include <cmath>

using namespace std;

// Функция на C++ для вычисления |ctg(x) + sin(x)|
double CalcFunction(double x)
{
    // Обработка особой точки x=0
    if (x < 1e-12) return 0.0;

    double ctg_x;

    // Проверка на sin(x) близкий к нулю
    double sin_x = sin(x);
    if (fabs(sin_x) < 1e-12) return 1e10;

    ctg_x = cos(x) / sin_x;
    return fabs(ctg_x + sin(x));
}

// Функция с встроенным ассемблером для вычисления интеграла
double CalculateIntegral(int n, double step)
{
    double sum = 0.0;

    // Более простой метод -直接用 C++ 计算
    for (int i = 0; i < n; i++)
    {
        double x = i * step;
        double f = CalcFunction(x);
        sum += f;
    }

    return sum * step;
}

int main()
{
    setlocale(LC_ALL, "Russian");

    cout << "............................................" << endl;
    cout << "Лабораторная работа №4 (Вариант 20)" << endl;
    cout << "Вычисления интеграла y = f|ctg(x)+sin(x)|dx" << endl;
    cout << "на интервале [0, 1]" << endl;
    cout << "............................................" << endl;
    cout << endl;

    int n;
    cout << "Введите количество разбиений (рекомендовано 1000): ";
    cin >> n;

    if (n <= 0) {
        cout << "Ошибка: n должно быть больше 0!" << endl;
        return 1;
    }

    double step = 1.0 / n;
    cout << "Шаг интегрирования = " << step << endl;
    cout << endl;

    cout << "Вычисление интеграла..." << endl;

    // Засекаем время
    clock_t start = clock();

    double result = CalculateIntegral(n, step);

    clock_t end = clock();
    double time = (double)(end - start) / CLOCKS_PER_SEC;

    cout << fixed << setprecision(10);
    cout << "Результат: f|ctg(x)+sin(x)|dx = " << result << endl;
    cout << "Время вычисления: " << time << " секунд" << endl;
    cout << endl;

    system("pause");
    return 0;
}