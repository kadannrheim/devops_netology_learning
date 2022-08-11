# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).
   
## Решение
```
sudo apt install golang
...
kadannr @ wcrow ~
└─ $ ▶ go version
go version go1.13.8 linux/amd64

```

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
 
1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 

## Решение

1. ```
   kadannr @ wcrow ~
└─ $ ▶ mkdir gowork
kadannr @ wcrow ~
└─ $ ▶  export GOPATH=$HOME/gowork/
kadannr @ wcrow ~/gowork
└─ $ ▶ vi base_go1.go
kadannr @ wcrow ~/gowork
└─ $ ▶ go run base_go1.go
Enter a number: 10
32.8
kadannr @ wcrow ~/gowork
└─ $ ▶ cat base_go1.go
package main

import "fmt"

func main() {
    fmt.Print("Enter a number: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := input * 3.28

    fmt.Println(output)
}
```
2. ```
kadannr @ wcrow ~/gowork
└─ $ ▶ vi base_go2.go
kadannr @ wcrow ~/gowork
└─ $ ▶ go run base_go2.go
The smallest number in the list: 9
kadannr @ wcrow ~/gowork
└─ $ ▶ cat base_go2.go
package main

import "fmt"
import "sort"

func GetMin (toSort []int)(minNum int) {
        sort.Ints(toSort)
        minNum = toSort[0]
        return
}

func main() {
        x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
        y := GetMin(x)
        fmt.Printf("The smallest number in the list: %v\n", y)
}
```
3. ```
kadannr @ wcrow ~/gowork
└─ $ ▶ vi base_go3.go
kadannr @ wcrow ~/gowork
└─ $ ▶ go run base_go3.go
0 -> 3, 6, 9,
12, 15, 18,
21, 24, 27, 30,
33, 36, 39,
42, 45, 48,
51, 54, 57, 60,
63, 66, 69,
72, 75, 78,
81, 84, 87, 90,
93, 96, 99,
kadannr @ wcrow ~/gowork
└─ $ ▶ cat base_go3.go
 package main

        import "fmt"


        func main() {

            for i := 1; i <= 100; i++ {
                if ((i-1)%100) ==0 {
                        fmt.Print(i-1," -> ")
                }

                if (i%3) == 0 {
                    fmt.Print(i,", ")
                    }
                if (i%10) ==0 {
                    fmt.Println()
                }
            }
        }
```
## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

