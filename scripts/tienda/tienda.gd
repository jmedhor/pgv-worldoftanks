extends Control

const MAX_NIVEL: int = Global.MAX_NIVEL_JUGADOR
const MAX_VIDA: int = Global.MAX_VIDA_JUGADOR

signal cerrar_tienda
signal cambio_puntos(nuevos:int)
signal cambio_arma(nueva:String)
signal filtro(nuevo:String, activo:bool)
signal cambio_nivel()
signal compra_vida()
signal compra_escudo()
var _puntos : int
var _arma : int
var _nivel : int
var _vida : int
var _escudo : bool
var filtro_actual = {"activo":false, "color":"ByN"}
var activar_rot : bool

var precio_vida : int = 2000
var precio_random : int = 10
var precio_escudo : int = 1000

var catalogo_strings = [
	"dmg",
	"emp",
]


var catalogo_iconos = [
	preload("res://assets/icons/dmg.png"),
	preload("res://assets/icons/emp.png")
]

var catalogo_niveles = [
	{"precio": 1500, "icono":preload("res://assets/icons/ammo-pistol 32px.png")},
	{"precio": 3000, "icono":preload("res://assets/icons/ammo-rifle 32px.png")}
]

func _ready() -> void:
	_puntos = 0
	%escudoPrecio.text = str(precio_escudo)
	%vidaPrecio.text = str(precio_vida)
	%randomPrecio.text = str(precio_random)
	%mejoraPrecio.text = str(catalogo_niveles.get(_nivel).get("precio"))

func _process(delta: float) -> void:
	if activar_rot:
		self.rotation_degrees+=1*delta
	else:
		if self.rotation_degrees>0:
			self.rotation_degrees-=1*delta

func set_puntos(nueva: int):
	_puntos = nueva
	%Dinero_tienda.text = str(_puntos)

func set_arma(nueva: String):
	_arma = catalogo_strings.find(nueva)
	%iconoArma.texture = catalogo_iconos.get(_arma)

func set_vida(nueva: int):
	_vida = nueva
	var estado : bool = _vida == MAX_VIDA
	%vidaSoldOut.visible = estado
	
func set_escudo(nuevo: bool):
	_escudo = nuevo
	%escudoSoldOut.visible = _escudo

func set_nivel(nuevo:int):
	_nivel = nuevo
	var estado : bool = (_nivel == MAX_NIVEL)
	%mejoraSoldOut.visible = estado
	if _nivel < MAX_NIVEL:
		%iconoMejora.texture = catalogo_niveles.get(_nivel).get("icono")
		%mejoraPrecio.text = str(catalogo_niveles.get(_nivel).get("precio"))

func _on_cerrar_tienda_pressed() -> void:
	print("Cerrando tienda")
	SaveManager.set_last_special(catalogo_strings[_arma])
	SaveManager.guardar_datos()
	cerrar_tienda.emit()

func _on_boton_siguiente_pressed() -> void:
	_arma = posmod(_arma + 1, catalogo_strings.size())
	%iconoArma.texture = catalogo_iconos.get(_arma)
	cambio_arma.emit(catalogo_strings.get(_arma))

func _on_boton_anterior_pressed() -> void:
	_arma = posmod(_arma - 1, catalogo_strings.size())
	%iconoArma.texture = catalogo_iconos.get(_arma)
	cambio_arma.emit(catalogo_strings.get(_arma))

func _on_boton_mejora_pressed() -> void:
	if _nivel < 2:
		var precio = catalogo_niveles.get(_nivel).get("precio")
		if _puntos >= precio:
			_puntos = _puntos - precio
			set_nivel(_nivel+1)
			%Dinero_tienda.text = str(_puntos)
			cambio_puntos.emit(_puntos)
			cambio_nivel.emit()
			
		else:
			print("No tienes puntos")
	else:
		print("Nivel maximo")
		elegir_error()


func _on_boton_vida_pressed() -> void:
	if _vida < MAX_VIDA:
		if _puntos >= precio_vida:
			_puntos = _puntos - precio_vida
			set_vida(_vida+1)
			%Dinero_tienda.text = str(_puntos)
			cambio_puntos.emit(_puntos)
			compra_vida.emit()
			precio_vida+=25
			%vidaPrecio.text = str(precio_vida)
		else:
			print("No tienes puntos")
	else:
		print("Vida al maximo...")
		elegir_error()

func _on_boton_escudo_pressed() -> void:
	if not _escudo:
		if _puntos >= precio_escudo:
			_puntos = _puntos - precio_escudo
			set_escudo(true)
			%Dinero_tienda.text = str(_puntos)
			cambio_puntos.emit(_puntos)
			compra_escudo.emit()
		else:
			print("No tienes puntos")
	else:
		print("Escudo activo...")
		elegir_error()

func _on_boton_random_pressed() -> void:
	if _puntos >= precio_random:
		_puntos = _puntos - precio_random
		cambio_puntos.emit(_puntos)
		%Dinero_tienda.text = str(_puntos)
		var opcion = randi_range(0,3)
		match opcion:
			0:
				print("FIUUU")
				activar_rot = !activar_rot
			1:
				print("BLANCO Y NEGRO FIUUUU")
				var actual = filtro_actual.get("color")
				var activo = true
				if actual == "byn":
					activo = false
				filtro_actual.set("filtro", activo)
				filtro.emit("byn", activo)
			2:
				print("Vn FIUUUU")
				var actual = filtro_actual.get("color")
				var activo = true
				if actual == "nv":
					activo = false
				filtro_actual.set("filtro", activo)
				filtro_actual.set("color", "nv")
				filtro.emit("nv", activo)
			3:
				var actual = filtro_actual.get("color")
				var activo = true
				if actual == "crt":
					activo = false
				filtro_actual.set("filtro", activo)
				filtro_actual.set("color", "crt")
				filtro.emit("crt", activo)
	else:
		print("No tienes puntos")
		elegir_error()

var sonidos = [
	preload("res://assets/sounds/error1.mp3"), 
	preload("res://assets/sounds/error2.mp3"), 
	preload("res://assets/sounds/error3.mp3"), 
	preload("res://assets/sounds/error_sound.wav")
	]

func elegir_error():
	$soundStream.stop()
	$soundStream.stream = sonidos.pick_random()
	$soundStream.play()
