# Practica 1
using StatsBase
using Distributions
using Random
using GLMakie

## Ejercicio 1: Manejar el entorno estadístico básico de Julia
### Apartado 1: Encuentre la manera de generar muestras aleatorias Gausianas en la
### documentación de Juliastats.
#### Sabemos que una distribución Gaussiana es una distribución Normal, por tanto:
gauss = Normal(0, 1)

### Hemos creado una muestra aleatoria gaussiana o normal con media 0 y varianza 1.

mean(gauss)
var(gauss)

###Apartado 2: Genere 10 muestras aleatorias de una variable aleatoria Gaussiana de
###media 0 y varianza 1, por ejemplo en el vector “muestra1”

muestra1 = Vector{Any}()
for i in 1:10
    push!(muestra1, Normal(0, 1))
end
println(muestra1);
### Apartado 3: Vuelva a generar 10 muestras aleatorias de una variable aleatoria
### Gaussiana de media 0 y varianza 1, esta vez en el vector “muestra2”

muestra2 = Vector{Any}()

for i in 1:10
    push!(muestra2, Normal(0, 1))
end
println(muestra2);

### Apartado 4: ¿Son iguales las muestras?
### Ambas son un vector de longitud 10, con v.a. gaussianas. Serán v.a. iguales.

## Ejercicio 2: Control de aleatoriedad
### Apartado 1: Encuentre el mecanismo de fijar la semilla de aleatoriedad de Julia.
### Fije la semilla a 1.
#Random.seed!()
muestra3 = Vector{Any}()

for i in 1:10
    push!(muestra3, rand(gauss, 10))
end
println(muestra3)
print("MEDIA DE: ")
println(mean(muestra3[1]))


## Ejercicio 3
### Apartado 1: . Genere ahora 10 muestras de tres variables aleatorias uniformes
### en los intervalos (0,1), (1,2) y (-1,1) y deles nombres adecuados.

uniform_01 = Uniform(0, 1);
uniform_12 = Uniform(1, 2);
uniform_11 = Uniform(-1, 1);

println(uniform_01)
println(uniform_12)
println(uniform_11)

### Apartado 2: . Genere también 10 muestras de una variable aleatoria Gaussiana
### de media 1 y varianza 1, otras tantas de media 0 y varianza 1, y
### por último, otras tantas de media 1 y varianza 2.

g1 = Normal(1, 1)
g2 = Normal(0, 1)
g3 = Normal(1, 2)
g4 = Normal(1, 1)
g5 = Normal(0, 1)
g6 = Normal(1, 2)
g7 = Normal(1, 1)
g8 = Normal(0, 1)
g9 = Normal(1, 2)
g10 = Normal(1, 2)

## Ejercicio 4: Cálculo de momentos muestrales
### Apartado 1: Encuentre cómo hallar momentos ordinarios y centrales de una muestra en
### Julia.
### Para calcular los momentos, necesitamos saber exactamente el orden del momento que
### necsitamos calcular. 
### Para momento 1:     media -- > mean()
### Para momento 2:  varianza -- > var()
### Para momento 3: asimetría -- > eskewness()
### Para momento 4:  curtosis -- > kurtosis()

### Apartado 2: Obtenga una muestra aleatoria de una variable aleatoria Gaussiana de media
## 2 y varianza 4, de tamaño 10, 100, y 1000 y calcule la media y la varianza
### muestral de cada muestra por separado.

gaussian_24 = Normal(2,2) # Queremos varianza 4, así que ponemos de std. = 2 => 2² = 4

g_size10 = rand(gaussian_24,10)
g_size100 = rand(gaussian_24,100)
g_size1000 = rand(gaussian_24,1000)
g_size100000 = rand(gaussian_24,100000)

m10 = mean(g_size10)
v10 = var(g_size10)
println(m10)
println(v10)

m100 = mean(g_size100)
v100 = var(g_size100)
println(m100)
println(v100)

m1000 = mean(g_size1000)
v1000 = var(g_size1000)
println(m1000)
println(v1000)

m10000 = mean(g_size10000)
v10000 = var(g_size100000)
println(m10000)
println(v10000)

### Apartado 3:  ¿Cuál de ellas cree que se acerca más a la media y a la varianza
### poblacional y por qué?
### Como es obvio, cuanto más muestras en la distribucion, más se acercará a los valores
### preestablecidos.

s1000 = skewness(g_size1000)
k1000 = kurtosis(g_size1000)
println(s1000)
println(k1000)
x=-1000:1000
fig = lines(x,g_size1000)