### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 5c385795-9307-45fd-b58e-60ada5aaa7de
begin 
	using Pkg
	Pkg.activate(".")
	Pkg.instantiate()
	using Plots
	using PlutoUI
	using BandedMatrices
	gr()
	backend();
	TableOfContents()
end

# ╔═╡ ba09b7e0-48e7-4423-9bd3-00a2b4dc8905
md"
# Modelo de Crecimiento Exponencial

## Descripción
Este es uno de los modelos teóricos más simples para el estudio de las poblaciones, resulta de asumir que la taza de crecimiento de la población es proporcional a la población en el tiempo actual. Lo anterior es expresado matemáticamente como:
 
$\frac{dP(t)}{dt} = \lambda P(t)$

En la ecuación anterior es $\lambda$ es una constante que representa cuan rápido una $P(t)$ (la población) crece o decrece. Si $\lambda > 0$ la población crece y si $\lambda < 0$ la población decrece.

Popularmente $\lambda$ es la suma de las tazas nacimientos y muertes por unidad de tiempo (usualmente tazas anuales), obtenidas mediante estadísticas de las poblaciones. 

La ecuación descrita es útil para predecir el futuro de las poblaciones realizando determinadas asunciones. De igual manera, representa una EDO con valor en la frontera donde se toma en cuenta la población inicial $P_0$. Finalmente la ecuación que predice la población está dada por:

$$P(t) = P_0 e^{\lambda t}$$

Esta ecuación no toma en cuenta la inmigración ni emigración, cuando ello sucede el planteamiento de la ecuación diferencial y la solución son:

$\frac{dP(t)}{dt} = [B-(D+E)] P(t) + I$

Si $[B-(D+E)] = \alpha$

$$P(t) = \dfrac{[\alpha P_0 + I] e^{\alpha t} - I}{\alpha}$$

Las tazas (usualmente anuales) $B$, $D$, $E$ corresponden a: nacimientos, muertes y emigración respectivamente.  $I$ constituye el número de individuos que se agregan a la población en el periodo de tiempo $t$.
"

# ╔═╡ 00bd976f-592e-4bf9-b6d3-7b1618a2da78
md"
## Simulación modelo BIDE
"

# ╔═╡ 5091b134-2c65-4205-8a41-a749ddfb0494
md"""
Población Inicial $P_0 =$ $(@bind P₀ html"<input id='v_0' type='number' min='0', value='1000'>")
"""

# ╔═╡ 8ed5dbd8-1523-4296-9109-dabd80203295
md"
$(@bind birthday Slider(0.1:0.1:1.0, show_value = true)) B (taza de natalidad anual) ---- [min = 0, max = 100]

$(@bind inmigrate Slider(0.0:1.0:10000.0, show_value = true)) I (Inmigración anual) ---- [min = 0, max = 10000]

$(@bind death Slider(0.0:0.1:1.0, show_value = true)) D (taza de mortalidad anual) ---- [min = 0, max = 100]

$(@bind emigrate Slider(0.0:0.1:1.0, show_value = true)) E (taza de emigración anual) ---- [min = 0, max = 100]
"

# ╔═╡ 85c58d32-3cec-4297-bc36-e3cc1c0c619a
begin
	md"""
	----
	
	$(@bind time Slider(0:1:70, show_value = true)) t (tiempo en años) ---- [min = 0, max = 70] 
	"""
end

# ╔═╡ 6b5724fd-6195-4b1b-adcf-f6f36fa928c9
md"
## Desventajas del modelo BIDE
Las ecuaciones anteriores presentan limitaciones cuando se intentan realizar prediciones acerca del crecimiento de una población, sucede porque no se toman en cuenta que para muchas poblaciones existen estructuras y condiciones que rigen la dinámica del crecimiento de la población. Además, se hacen las siguientes asunciones, que aplican a un número reducido de casos de uso:

+ Las tazas son constantes (en general pueden variar con respecto al tiempo).
+ No se toma en cuenta la estructura genética de la población.
+ No se toma en cuenta la estructura de tamaño y edad de la población.
+ No existe retraso entre eventos de nacimiento y su paso a la etapa reproductiva.

En vista de ello se pasa a realizar un modelo de predicción  con base a la estructura de edades de la población.
"

# ╔═╡ 4bb9e9d5-a185-4b12-a048-8ba0aada55d2
md"
# Age Structure Model


"

# ╔═╡ 7f2111c3-1c9c-4b49-803e-96ba47714518
clases = ["1" "2" "3" "4" "Población total"];

# ╔═╡ e6443342-e2be-41df-a541-1ac22073cbef
Fᵢ = [0.9, 0.8, 0.9, 0.4];

# ╔═╡ 40cb285c-83e3-45d3-bf02-d02839bc9d4f
Probᵢ = [0.8, 0.9, 0.95, 0.9];

# ╔═╡ f0e95ee1-217d-4c00-b3ac-2f0080b2c0e3
Pob₀ = [20; 25; 30; 23];

# ╔═╡ b44bae56-8410-4f0d-ba6d-8661a420dd15
md"""
Años de predicción $(@bind years NumberField(0:1:100))
"""

# ╔═╡ d51f23a4-fe65-46a9-9328-6df7c411d43b
md"
# Preparación del Ambiente
"

# ╔═╡ 9f012880-f59e-4c79-b1a3-4159da152dbb
md"
## Definición de funciones
"

# ╔═╡ 3ced747c-cee3-4d88-9548-5c2aa86ebf69
model(P₀, B, I, D, E, t) = (B-(D+E))P₀*exp(t*(B-(D+E)))/(B-(D+E)) - I/(B-(D+E))

# ╔═╡ 8a1e33e9-40f1-4bb5-9b92-116b728c4b7a
pop = model.(P₀, birthday, inmigrate, death, emigrate, time);

# ╔═╡ a6e5acf0-50be-4e13-8e58-3b504f774207
begin
	t = 0:1:70
	p = model.(P₀, birthday, inmigrate, death, emigrate, t)
	plot(t, p, title = "Predicción del Modelo", ylabel = "Población", xlabel = "Tiempo (años)", xticks = (0:5:70), legend = :top, label = "Predicción Modelo BIDE")
	scatter!((time, pop), markerstrokecolor = :red, markercolor = :red, markersize = 5, label = "($(time),$(convert(Int,floor(pop))))")
end

# ╔═╡ bae9160f-a77f-4d7f-9e53-3b62b0a89750
macro ninputs(args...)
	n = args[end]
	quote
		[$(map(function(sym)
					quote
						@bind $(sym) @bind x NumberField(0.0:1.0) 
					end
						end, args[1:end-1])...)]
	end
end

# ╔═╡ 4f667701-4965-41b7-9701-3c2b14d42f44
function makematrixleslie(probsurvival, fecundity)
	n = length(fecundity)
	count₁ = 1
	count₂ = 1
	lesliematrix = zeros(n, n)
	for i in 1:length(lesliematrix)
		if i == 1 || (i-1)%n == 0
			lesliematrix[i] = fecundity[count₁]
			count₁ +=1
		elseif i == 2 || (i-8*(count₂-1))==2
			lesliematrix[i] = probsurvival[count₂]
			count₂ +=1
		end
	end
	return lesliematrix
end

# ╔═╡ 36a8b372-587d-414f-924d-9c79a582e553
begin
	lesliematrix = makematrixleslie(Probᵢ, Fᵢ);
	Pob = copy(Pob₀')
	Pobₜ = []
	for i in 1:years
		if i == 1 
			global temp = lesliematrix*Pob₀
		elseif i != 1
			global temp = lesliematrix*temp 
		end
		push!(Pobₜ, sum(temp))
		global Pob = vcat(Pob,temp')
	end 
	pushfirst!(Pobₜ, sum(Pob₀))
end;

# ╔═╡ 1a2f142c-9a56-40f0-bddb-d9a85faeb696
plot( [Pob, Pobₜ], label = clases, ylabel = "Población", xlabel = "Tiempo (años)", title = "Proyecciónes")

# ╔═╡ Cell order:
# ╟─ba09b7e0-48e7-4423-9bd3-00a2b4dc8905
# ╟─00bd976f-592e-4bf9-b6d3-7b1618a2da78
# ╟─5091b134-2c65-4205-8a41-a749ddfb0494
# ╟─8ed5dbd8-1523-4296-9109-dabd80203295
# ╟─85c58d32-3cec-4297-bc36-e3cc1c0c619a
# ╟─8a1e33e9-40f1-4bb5-9b92-116b728c4b7a
# ╟─a6e5acf0-50be-4e13-8e58-3b504f774207
# ╟─6b5724fd-6195-4b1b-adcf-f6f36fa928c9
# ╟─4bb9e9d5-a185-4b12-a048-8ba0aada55d2
# ╠═7f2111c3-1c9c-4b49-803e-96ba47714518
# ╠═e6443342-e2be-41df-a541-1ac22073cbef
# ╠═40cb285c-83e3-45d3-bf02-d02839bc9d4f
# ╠═f0e95ee1-217d-4c00-b3ac-2f0080b2c0e3
# ╟─b44bae56-8410-4f0d-ba6d-8661a420dd15
# ╟─36a8b372-587d-414f-924d-9c79a582e553
# ╟─1a2f142c-9a56-40f0-bddb-d9a85faeb696
# ╟─d51f23a4-fe65-46a9-9328-6df7c411d43b
# ╠═5c385795-9307-45fd-b58e-60ada5aaa7de
# ╟─9f012880-f59e-4c79-b1a3-4159da152dbb
# ╠═3ced747c-cee3-4d88-9548-5c2aa86ebf69
# ╟─bae9160f-a77f-4d7f-9e53-3b62b0a89750
# ╠═4f667701-4965-41b7-9701-3c2b14d42f44
