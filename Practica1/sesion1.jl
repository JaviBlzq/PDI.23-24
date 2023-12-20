#= En esta sesión vamos a sentar las bases para el procesamiento digital de audio.
Tras esta sesión seremos capaces de crear un entorno de procesamiento de audio en el
lenguaje Julia, con ello, podremos trabajar con estas señales, ya sea para analizarlas
y/o visualizar la forma de onda, o, para reroducir estos sonidos, siendo capaces de
haber modificado la señal.

Tenemos una serie de actividades, o hitos, para la completa realización de este entorno
de procesado.
=#
# Actividad 0
#= Llevaremos a cabo el tutorial inicial para la preparación de este entorno.
El mini tutorial está alojado en: 
https://marketsplash.com/tutorials/julia/julia-audio-processing/#Setting%20Up%20Julia%20For%20Audio%20Processing

Setting Up Julia For Audio Processing

Lo primero será agregar el paquete para poder trabajar con nuestros archivos de audio,
en formato ".wav". Desde la terminal, nos descargaremos el paquete, llamado "WAV",
con los siguientes comandos, dentro de la terminal de Julia:
>> using Pkg
>> Pkg.add("WAV")

Se nos descargará el paquete.

Añadiremos el paquete a nuestro fichero:
=#
using WAV

#=
Vamos a empezar, cargando un archivo .wav usando el paquete que acabamos de agregar. 
Como tenemos un directorio lleno de ficheros .wav, cogeremos, como ejemplo, usaremos
"guitar.wav"
Con la función "wavread", obtendremos los datos del audio, y la frecuencia del muestreo.
=#

y, fs = wavread("wavfilesLH1/trumpet.wav")

#=
Con esto, tenemos ya los datos del audio y su frecuencia de muestreo. Podemos probar
ahora a, por ejemplo, reproducirlo, para ello, tendremos primero que descargarnos el
paquete Sound, de la misma manera que antes:
>> using Pkg
>> Pkg.add("Sound")

Añadimos el paquete y probamos como se oye:

Si seguimos sólo el tutorial, nos damos cuenta que: sound.play() no existe, o en las
últimas versiones de Sound, ha sid modificado. Según la documentación de SOund, la
función a utilizar es: sound(y,fs)

=#
using Sound
sound(y,fs)


# Al ejecutar, se escucha el sonido de la guitarra.

#= Teniendo los datos del audio de la guitarra, podemos modificarlos, y ver como varía
el audio de la guitarra, según los parámetros modificados.

Podemos modificar la amplitud de los datos, es decir, modificar el VOLUMEN de la señal,
la intensidad. Esto se consigue multiplicar los datos por un factor. Si el factor es
mayor que uno, estaremos ampificando la señal, y por tanto, su VOLUMEN será mayor,
o en cambio, si el factor es menor de 1, pero mayor que 0, para no anular la señal,
estaremos atenuándola, y por consiguiente, reduciendo su volumen.

El factor por el que se verá modificada la señal, lo llamaremos k.

Si este factor, es mayor que 1, puede ocasionar clipping, es decir, la señal se ve 
recortadaen los extremos de máxima amplitud, producido por la sobredimensión de esta.

=#

k = 1.5
y_modif = y * k

sound(y_modif,fs)

k = 0.5
y_modif = y * k
sound(y_modif,fs)

#= Notamos, que el volumen de la señal se ve modificado. Notamos como el factor ha
alterado la señal.

Vamos a representar la señal. Usaremos el paquete GLMakie, que tiene como fondo backend,
la librería Makie. La librería Makie es ampliamente utilizada.

GLMakie permite la interactividad, pudiendo interactuar con las gráficas.

Si no está instalado, ejecutaremos en la terminal Julia:
>> using Pkg
>> Pkg.add("GLMakie")

Ahora con este paquete, dibujamos la señal, en el dominio del tiempo.
=#
using GLMakie

t = 1:1:length(y)
fig = lines(t,y[t])

#=Tenemos representada nuestra función de la señal de audio.

Como se ve alterada nuestra gráfica, si cogemos, la señal original comparándola con la señal
"atenuada" o bajada de volumen.

Usaremos la variable, creada antes, y_modif, que ya está atenuada por un factor 0.5.

=#
fig1 = Figure()
lines(fig1[1, 1], t, y[t], color = :red)

fig2 = Figure()
lines(fig2[1, 1], t, y_modif[t], color = :blue)

combined_figure = Figure()
lines(combined_figure[1, 1], t, y[t], color = :red)
lines(combined_figure[1, 2], t, y_modif[t], color = :blue)

fig1
fig2
combined_figure

#= La figura de color rojo, es la señal original, vemos que su amplitud llega más allá de 0.5,
superándolo por creces en los momentos de mayor intensidad. Sin embargo, la señal atenuada,
en su mayor momento de amplitud, solo llega a 0.4.
=#

#= Anteriormente, hemos modificado el valor de la intensidad, ampliando o disminuyendo, 
el volumen de la señal es lo que se ve alterado. Pero, tenemos otro parámetro que podemos
modificar, este es la frecuencia de muestreo.

La frecuencia de muestreo nos dice como de rápido o de lento, se ejecutan las muestras que
tenemos. Esto quiere decir, que con una frecuencia mayor, la señal sonará durante menos tiempo,
además, también observaremos que el tono de la señal es modificado. Si la frecuencia de muestreo
aumenta, el tono se agudiza.

Esto es solo experimental, vamos a probarlo.
=#

k = 1.5
fs_modif = k * fs

# Escuhemos la señal
sound(y,fs_modif)

#= Nuestras teorías son confirmadas. La forma de la señal NO se ve alterada, no tocamos ningún
valor de la señal, solo la frecuencia a la que se ejecutan esas muestras.
=#

# Implementing Audio Filters

#= Como sabemos, existen diferentes tipos de filtros. Existen filtros temporales, pero, también,
y siendo los que nos interesan, filtros frecuenciales.

Los filtros frecuenciales son aquellos que, al pasar la señal por ellos, solo deja atravesar unas
determinadas frecuencias. Según el rango de frecuencias que deje atravesar, hay diferentes tipos
de filtros. 

Filtros paso bajo, paso alto, paso banda son los filtros más populares, debido a su aplicación.

Para poder filtrar, nos ayudaremos del paquete DSP.

Empezaremos por los filtros paso bajo. Estos, dejan pasar la señal desde las frecuencias cercanas
a 0, hasta nuestro valor de corte.

Usaremos una frecuencia de corte de 1000 Hertz.
=#
using DSP
cutoff_frequency = 0.01 # Example value in Hz
lpf = Butterworth(1)  # 1st order Butterworth filter
filtered_signal = filt(digitalfilter(Lowpass(cutoff_frequency), lpf), y)

low_cutoff = 0.8
high_cutoff = 0.9
bpf = Butterworth(1)
filtered_signal = filt(digitalfilter(Bandpass(low_cutoff, high_cutoff), bpf), y)

cutoff_frequency = 0.1 # Example value in Hz
lpf = Butterworth(1)  # 1st order Butterworth filter
filtered_signal2 = filt(digitalfilter(Lowpass(cutoff_frequency), lpf), y)

cutoff_frequency = 0.99 # Example value in Hz
lpf = Butterworth(1)  # 1st order Butterworth filter
filtered_signal3 = filt(digitalfilter(Lowpass(cutoff_frequency), lpf), y)

# Usaremos un filtro paso bajo Butterworth de primer orden, pero podría ser otro.

fig1 = Figure()
lines(fig1[1, 1], t, y[t], color = :red)

fig2 = Figure()
lines(fig2[1, 1], t, filtered_signal[t], color = :blue)

fig3 = Figure()
lines(fig2[2, 1], t, filtered_signal2[t], color = :green)

fig4 = Figure()
lines(fig2[2, 2], t, filtered_signal2[t], color = :black)


combined_figure = Figure()
lines(combined_figure[1, 1], t, y[t], color = :red)
lines(combined_figure[1, 2], t, filtered_signal[t], color = :blue)
lines(combined_figure[2, 1], t, filtered_signal2[t], color = :green)
lines(combined_figure[2, 2], t, filtered_signal2[t], color = :black)

fig1
fig2
fig3
fig4
combined_figure

sound(y,fs)
sound(filtered_signal,fs)
sound(filtered_signal2,fs)
sound(filtered_signal3,fs)

