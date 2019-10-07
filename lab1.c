#include <stdio.h>
#include <stdlib.h>

#define EPS 1e-4


typedef struct points{
    float first;
    float second;
} points;


points solve(float a, float b, float c) {
    const float two = 2.0, four = 4.0;
    float ans1, ans2;

    __asm__ __volatile__(
            "FLD %2 ;"
            "FLD %2 ;"
            "FMUL ;"
            "FLD %4 ;"
            "FLD %1 ;"
            "FMUL ;"
            "FLD %3 ;"
            "FMUL ;"
            "FSUBR ;"
            "FSQRT ;"
            "FLD %2 ;"
            "FCHS ;"
            "FADD ;"
            "FDIV %1 ;"
            "FDIV %5 ;"
            "FSTP %0 ;"
            : "=m"(ans1)
            : "m"(a), "m"(b), "m"(c), "m"(four), "m"(two)
            );

    __asm__ __volatile__(
            "FLD %2 ;"
            "FLD %2 ;"
            "FMUL ;"
            "FLD %4 ;"
            "FLD %1 ;"
            "FMUL ;"
            "FLD %3 ;"
            "FMUL ;"
            "FSUBR ;"
            "FSQRT ;"
            "FLD %2 ;"
            "FCHS ;"
            "FSUB ;"
            "FDIV %1 ;"
            "FDIV %5 ;"
            "FSTP %0 ;"
            : "=m"(ans2)
            : "m"(a), "m"(b), "m"(c), "m"(four), "m"(two)
            );

    points res;
    res.first = ans1;
    res.second = ans2;
    return res;
}

// equation b*x + c = 0

float linear_solve(float b, float c) {

    float ans;

    __asm__ __volatile__ (
            "FLD %2 ;"
            "FCHS ;"
            "FDIV %1 ;"
            "FSTP %0 ;"
            : "=m"(ans)
            : "m"(b), "m"(c)
            );

    return ans;
}


int main(){
    float a, b, c, D;
    printf("The program solve quadratic equation of the form a*x^2 + b*x + c = 0\n\n");
    printf("Input coefficients a, b, c to solve equation\n");
    printf("a = ");
    scanf("%f", &a);
    printf("b = ");
    scanf("%f", &b);
    printf("c = ");
    scanf("%f", &c);

    if (fabs(a) < EPS) {
        if (fabs(b) < EPS) {
            printf("\nThere are no roots. a = 0 and b = 0.\n");
            return 0;
        }
        float res = linear_solve(b, c);
        printf("\nThe equation was reduced to linear.\nThe only root is x = %f\n", res);
        return 0;
    }

    D = b * b - 4. * a * c;
    if (fabs(D) < EPS) {
        points res = solve(a, b, c);
        printf("\nThe only root is x = %f\n", res.first);
    } else if (D > 0) {
        points res = solve(a, b, c);
        printf("\nThe roots are x1 = %f, x2 = %f\n", res.first, res.second);
    } else {
        printf("\nThere are no roots. Discriminant is less than zero.\n");
    }

    printf("\n");
    return 0;
}
