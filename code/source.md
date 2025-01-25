c语言测试代码

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function to add two numbers
int add(int a, int b) {
    return a + b;
}

int main() {
    int x = 10, y = 20, result;
    result = add(x, y);
    printf("The result is: %d\n", result);

    // Loop example
    for (int i = 0; i < 5; i++) {
        printf("Loop index: %d\n", i);
    }

    return 0;
}
```

python语言测试代码

```python
# Import necessary libraries
import math
import os

# Function to calculate the square root
def calculate_sqrt(number):
    return math.sqrt(number)

if __name__ == "__main__":
    number = 16
    result = calculate_sqrt(number)
    print(f"The square root of {number} is {result}")

    # Loop example
    for i in range(5):
        print(f"Loop index: {i}")
```

matlab语言测试代码

```matlab
% Function to calculate the square root
function result = calculate_sqrt(number)
    result = sqrt(number);
end

% Main script
number = 16;
result = calculate_sqrt(number);
fprintf('The square root of %d is %.2f\n', number, result);

% Loop example
for i = 1:5
    fprintf('Loop index: %d\n', i);
end
```

