### A Pluto.jl notebook ###
# v0.12.21

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
end

# ╔═╡ 5091b134-2c65-4205-8a41-a749ddfb0494
@bind P₀ html"<input id='v_0' type='number' min='0', value='1000.0'>"

# ╔═╡ 8ed5dbd8-1523-4296-9109-dabd80203295
md"
B $(@bind birthday Slider(0.0:0.1:1.0))
I $(@bind inmigrate Slider(0.0:0.1:1.0))
D $(@bind death Slider(0.0:0.1:1.0))
E $(@bind emigrate Slider(0.0:0.1:1.0))
"

# ╔═╡ 3ced747c-cee3-4d88-9548-5c2aa86ebf69
model(P₀, B, I, D, E, t) = P₀*exp(t*((B+I)-(D+E)))

# ╔═╡ d93b415c-0557-47ea-878c-6a5a05b46b30
begin
	t = 0:1:100
	p = model.(P₀, birthday, inmigrate, death, emigrate, t)
end;

# ╔═╡ a6e5acf0-50be-4e13-8e58-3b504f774207
plot(t, p)

# ╔═╡ Cell order:
# ╠═5c385795-9307-45fd-b58e-60ada5aaa7de
# ╟─5091b134-2c65-4205-8a41-a749ddfb0494
# ╟─8ed5dbd8-1523-4296-9109-dabd80203295
# ╠═3ced747c-cee3-4d88-9548-5c2aa86ebf69
# ╠═d93b415c-0557-47ea-878c-6a5a05b46b30
# ╠═a6e5acf0-50be-4e13-8e58-3b504f774207
