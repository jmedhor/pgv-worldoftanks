extends Control

const MAX_NIVEL: int = Global.MAX_NIVEL_JUGADOR
const MAX_VIDA: int = Global.MAX_VIDA_JUGADOR

signal cerrar_tienda
signal cambio_puntos(nuevos:int)
signal cambio_arma(nueva:String)
signal cambio_nivel(nuevo:int)
signal compra_vida()
signal compra_escudo()
var _puntos : int
var _arma : int
var _nivel : int
var _vida : int
var _escudo : bool
var activar_rot : bool

var catalogo_strings = [
	"dmg",
	"emp",
]

var catalogo_iconos = [
	preload("res://assets/icons/dmg.png"),
	preload("res://assets/icons/emp.png")
]

var catalogo_niveles = [
	100,
	500
]

func _ready() -> void:
	_puntos = 0

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

func _on_cerrar_tienda_pressed() -> void:
	print("Cerrando tienda")
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
		var precio = catalogo_niveles.get(_nivel)
		if _puntos >= precio:
			_puntos = _puntos - precio
			set_nivel(_nivel+1)
			%Dinero_tienda.text = str(_puntos)
			cambio_puntos.emit(_puntos)
			cambio_nivel.emit(_nivel)
			
		else:
			print("No tienes puntos")
	else:
		print("Nivel maximo")
		elegir_error()


func _on_boton_vida_pressed() -> void:
	if _vida < MAX_VIDA:
		var precio = 100
		if _puntos >= precio:
			_puntos = _puntos - precio
			set_vida(_vida+1)
			%Dinero_tienda.text = str(_puntos)
			cambio_puntos.emit(_puntos)
			compra_vida.emit()
		else:
			print("No tienes puntos")
	else:
		print("Vida al maximo...")
		elegir_error()

func _on_boton_escudo_pressed() -> void:
	if not _escudo:
		var precio = 100
		if _puntos >= precio:
			_puntos = _puntos - precio
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
	activar_rot = !activar_rot

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
