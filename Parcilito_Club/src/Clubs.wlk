class Club {

	var sanciones = #{}
	var actividades = #{}
	var property socios = #{}
	var property gastosMensuales=0
	
	method agregarActividad(actividad){
		actividades.add(actividad)
	} 
	
	method removerActividad(actividad){
		actividades.remove(actividad)
	} 
	
	
	method sacarSocio(socio){
		socios.remove(socio)	
	}
	
	method agregarSocio(socio){
		socios.add(socio)	
	}
	
	method socioEstrella(socio) {
		return null
	}
	
	method sancionarClub (sancion){
		if (self.cantSocios()>500){
		actividades.forEach({actividad => actividad.sancionar()})
	}else{
		throw new Exception("No se puede sancionar el club tiene menos de 500 socios")
		}
		}
	
	method cantSocios(){
		return socios.size()
	}
	method evaluacionBruta(){return null}
	
	method sociosDestacados(){
		return actividades.filter({actividad=> actividad.destacado()})
	}
	
	method socioDestacadoYEstrella(){
		return self.sociosDestacados().filter({socio => socio.esEstrella()})
	}
	
	method esPrestigioso(){
		return actividades.filter({actividad=> actividad.esEsperimentado()}).size() >= 1
	}
	
	
	method transferirAOtroClub (club,socio){
		if(!self.socios().contains(socio) && !socio.soyDestacado()){
			club.agregarSocio(socio)
			self.sacarSocio(socio)
			socio.sacarDeActividades()
		}else{
			throw new Exception("El socio pertenece al mismo club")
		}
		
	}
}


//------------------------------------------------------------------------------------------------------------------------------------
class ClubTradicional inherits Club {

	override method socioEstrella(socio) {
		return socio.valorPase() > valorConfigurablePase.valorPase() || socio.actividadesQueParticipo() > 3 
	}
	
	override method evaluacionBruta(){
		return actividades.sum({actividad=>actividad.evaluacion()}) - self.gastosMensuales()
	}

}

//-----------------------------------------------------------------------------------------------------------------------------------
class ClubComunitario inherits Club {

	override method socioEstrella(socio) {
		return socio.actividadesQueParticipo() > 3
	}
	
	override method evaluacionBruta(){
		return actividades.sum({actividad=>actividad.evaluacion()})
	}

}

//-------------------------------------------------------------------------------------------------------------------------------------
class ClubProfecional inherits Club {

	override method socioEstrella(socio) {
		return socio.valorPase() > valorConfigurablePase.valorPase()
	}
	
	override method evaluacionBruta(){
		return (actividades.sum({actividad=>actividad.evaluacion()})*2) - (self.gastosMensuales()*5)
	}

}
//------------------------------------------------------------------------------------------------------------------------------------

class Socio {

	var  clubAlQuepertenece
	var property aniosEnLaInstitucion = 0
	var  actividadesQueParticipo = #{}
	
	method sacarDeActividades(){
		actividadesQueParticipo.forEach({actividad => actividad.sacarIntegrante(self)})
	}
	
	method agregarALaActividades(){
		actividadesQueParticipo.forEach({actividad => actividad.agregarIntegrante(self)})
	}

	method esEstrella() {
		return self.aniosEnLaInstitucion()>20
	}

	method aniosEnLaInstitucion() {
		return aniosEnLaInstitucion
	}
	
	method actividadesQueSoyParticipe(){
		return actividadesQueParticipo
	}
	
	
	
	method actividadesQueParticipo(){
		return self.actividadesQueSoyParticipe().size()
	}
	
	method soyDestacado(){
		return self.actividadesQueSoyParticipe().filter({actividad => actividad.destacado()}).contains(self)
	}

}

//-----------------------------------------------------------------------------------------------------------------------------------
class Jugador inherits Socio {

	var property cantPartidos = 0
	var property valorPase = 0

	 override method esEstrella() {
		return self.cantPartidos()> 50 
	}

}

//-------------------------------------------------------------------------------------------------------------------------------------
class ActividadSocial {

	var sanciones = #{}
	var property socioOrganizador
	var property participantes = #{}
	var  estaSuspendida =false
	var valorEvaluacion 
	
	method agregarIntegrante(socio){
		participantes.add(socio)
	}
	method sacarIntegrante(socio){
		participantes.remove(socio)
	}
	
	method sancionar(){
		estaSuspendida = true
	}
	
	method reanudarActividad(){
		estaSuspendida = false
	}
	
	method estaSuspendida(){
		return estaSuspendida
	}
	
	method evaluacion(){
		if(self.estaSuspendida()){
		return 0
		
		}else{
		return valorEvaluacion
		
		}
	}
	method destacado(){
		return self.socioOrganizador()
	}
	
	method esperimentadosDeLaActividad(){
		return participantes.filter({participante=> participante.esEstrella()})
		
	}
	method esEsperimentado(){
		return self.esperimentadosDeLaActividad().size()>= 5
	}
	

}


//------------------------------------------------------------------------------------------------------------------------------------
class Equipo inherits ActividadSocial{

	var cantSanciones =0
	var property capitan
	var campeonatosObtenidos= 0
	
	
	override method sancionar(){
		cantSanciones ++
	}
	
	override method evaluacion(){
		return (campeonatosObtenidos*5) + (self.participantes().size() *2) + (self.capitanEsEstrella()) - (cantSanciones*20)	
	}
	
	method capitanEsEstrella(){
		if(self.capitan().esEstrella()){
		return 5
	}else{
		return 0
	}
	
	}
	
	method cantSanciones (){
		return cantSanciones
	}
	
	override method destacado(){
		return self.capitan()
	}
	
	override method esEsperimentado(){
		return participantes.all({jugador=> jugador.cantPartidos()>=10})
	}
	
	method transferir(socio){
		
	}
	

}

//------------------------------------------------------------------------------------------------------------------------------------

class EquipoFutboll inherits Equipo{
	
	method estrellasDelEquipo(){
		return participantes.filter({jugador => jugador.esEstrella()})
	}
	
	override method evaluacion(){
		return super() + (self.estrellasDelEquipo().size()*5) - (self.cantSanciones()*10)
	}
	
}

//--------------------------------------------------------------------------------------------------------------------------------------
object valorConfigurablePase {

	var property valorPase = 1000

}

